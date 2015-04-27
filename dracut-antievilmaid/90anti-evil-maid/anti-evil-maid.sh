#!/bin/bash
#
# Anti Evil Maid for dracut by Invisible Things Lab
# Copyright (C) 2010 Joanna Rutkowska <joanna@invisiblethingslab.com>
#
# Mount our device, read the sealed secret blobs, initilize TPM
# and finally try to unseal the secrets and display them to the user
#

DEV=/dev/antievilmaid
MNT=/antievilmaid
SEALED_SECRET=$MNT/antievilmaid/sealed_secret.blob
UNSEALED_SECRET=/tmp/unsealed-secret
PLYMOUTH_THEME_UNSEALED_SECRET=/usr/share/plymouth/themes/qubes-dark/antievilmaid_secret.png


export PATH="/sbin:/usr/sbin:/bin:/usr/bin:$PATH"
. /lib/dracut-lib.sh
type ask_for_password >/dev/null 2>&1 || . /lib/dracut-crypt-lib.sh

shopt -s expand_aliases
if type plymouth >/dev/null 2>&1; then
     alias plymouth_maybe=plymouth
else
     alias plymouth_maybe=:
fi

PLYMOUTH_MESSAGES=()
function message() {
    if type plymouth >/dev/null 2>&1 && plymouth --ping 2>/dev/null; then
        plymouth message --text="$1"
        PLYMOUTH_MESSAGES+=("$1")
    else
        echo "$1"
    fi
}


if [ -d "$MNT" ] ; then
    info "$MNT already exists, skipping..."
    exit 0
fi

info "Waiting for antievilmaid boot device to become available..."
while ! [ -b "$DEV" ]; do
    sleep 0.1
done

info "Mounting the antievilmaid boot device..."
mkdir "$MNT"
mount "$DEV" "$MNT"

info "Initializing TPM..."
modprobe tpm_tis
ip link set dev lo up
mkdir -p /var/lib/tpm/
cp "$MNT/antievilmaid/system.data" /var/lib/tpm/
tcsd

TPM_ARGS="-o $UNSEALED_SECRET"
if ! getarg rd.antievilmaid.asksrkpass; then
    info "Using default TPM SRK unseal password"
    TPM_ARGS="$TPM_ARGS -z"
fi

message "Attempting to unseal the secret from the TPM..."
message ""

if [ -f "$SEALED_SECRET" ] ; then
    #we set tries to 1 as some TCG 1.2 TPMs start "protecting themselves against dictionary attacks" when there's more than 1 try within a short time... -_- (TCG 2 fixes that)
    if getarg rd.antievilmaid.asksrkpass; then
        ask_for_password --cmd "tpm_unsealdata $TPM_ARGS -i $SEALED_SECRET" --prompt "TPM SRK unseal password" --tries 1
            #--tty-echo-off
    else
        tpm_unsealdata $TPM_ARGS -i $SEALED_SECRET
    fi
    message "$(cat "$UNSEALED_SECRET" 2>/dev/null)"
else
    message "No data to unseal. Do not forget to generate a ${SEALED_SECRET##*/}"
fi

if getarg rd.antievilmaid.png_secret; then
    message ""
    message "Continue the boot process only if the secret image next to the password prompt is correct!"
    message ""
else
    message ""
    message "Continue the boot process only if the secret above is correct!"
    message ""
fi
info "Unmounting the antievilmaid device..."
umount "$MNT"

# Verify if the unsealed PNG secret seems valid and replace the lock icon
if getarg rd.antievilmaid.png_secret; then
    if file "$UNSEALED_SECRET" 2>/dev/null | grep -q PNG; then
        cp "$UNSEALED_SECRET" "$PLYMOUTH_THEME_UNSEALED_SECRET"
    fi
fi

plymouth_maybe pause-progress
if getarg rd.antievilmaid.dontforcestickremoval; then
    if ! getarg rd.antievilmaid.png_secret; then
        message "Press <SPACE> to continue..."
        plymouth_maybe watch-keystroke --keys=" "
    fi
else
    message "Remove your Anti Evil Maid stick to continue..."
    while [ -b "$DEV" ]; do
        sleep 0.1
    done
fi
plymouth_maybe unpause-progress

if ! getarg rd.antievilmaid.dontforcestickremoval || ! getarg rd.antievilmaid.png_secret; then
    for m in "${PLYMOUTH_MESSAGES[@]}"; do
        plymouth_maybe hide-message --text="$m"
    done
fi
rm -f "$UNSEALED_SECRET"
