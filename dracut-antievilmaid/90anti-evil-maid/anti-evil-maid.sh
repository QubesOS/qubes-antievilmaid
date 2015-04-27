#!/bin/bash
#
# Anti Evil Maid for dracut by Invisible Things Lab
# Copyright (C) 2010 Joanna Rutkowska <joanna@invisiblethingslab.com>
#
# Mount our device, read the sealed secret blobs, initilize TPM
# and finally try to unseal the secrets and display them to the user
#


. /lib/dracut-lib.sh

command -v ask_for_password >/dev/null || . /lib/dracut-crypt-lib.sh

PLYMOUTH_MESSAGES=()
function message() {
    if type plymouth >/dev/null 2>&1 && plymouth --ping 2>/dev/null; then
        plymouth message --text="$1"
        PLYMOUTH_MESSAGES+=("$1")
    else
        echo "$1"
    fi
}

if [ -d /antievilmaid ] ; then
    info "/antievilmaid already exists, skipping..."
    exit 0
fi

info "Waiting for antievilmaid boot device to become available..."
while ! [ -b /dev/antievilmaid ]; do
    sleep 0.1
done

info "Mounting the antievilmaid boot device..."
mkdir /antievilmaid
mount /dev/antievilmaid /antievilmaid

info "Initializing TPM..."
/sbin/modprobe tpm_tis
ip link set dev lo up
mkdir -p /var/lib/tpm/
cp /antievilmaid/antievilmaid/system.data /var/lib/tpm/
/usr/sbin/tcsd

plymouth_theme=/usr/share/plymouth/themes/qubes-dark
if getarg rd.antievilmaid.png_secret; then
    TPMARGS="-o $plymouth_theme/secret.png"
else
    TPMARGS="-o /tmp/unsealed-secret.txt"
fi

if ! getarg rd.antievilmaid.asksrkpass; then
    info "Using default SRK password"
    TPMARGS="$TPMARGS -z"
fi

message "Attempting to unseal the secret passphrase from the TPM..."
message ""

if [ -f /antievilmaid/antievilmaid/sealed_secret.blob ] ; then
    #we set tries to 1 as some TCG 1.2 TPMs start "protecting themselves against dictionary attacks" when there's more than 1 try within a short time... -_- (TCG 2 fixes that)
    if getarg rd.antievilmaid.asksrkpass; then
        ask_for_password --cmd "/usr/bin/tpm_unsealdata $TPMARGS -i /antievilmaid/antievilmaid/sealed_secret.blob" --prompt "TPM Unseal Password" --tries 1
            #--tty-echo-off
    else
        /usr/bin/tpm_unsealdata $TPMARGS -i /antievilmaid/antievilmaid/sealed_secret.blob
    fi
    message "`cat /tmp/unsealed-secret.txt 2> /dev/null`"
else
    message "No data to unseal. Do not forget to generate a sealed_secret.blob"
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
umount /dev/antievilmaid

# Verify if the unsealed PNG secret seems valid and replace the lock icon
if getarg rd.antievilmaid.png_secret; then
    if file $plymouth_theme/secret.png 2>/dev/null | grep PNG > /dev/null ; then
        cp $plymouth_theme/secret.png $plymouth_theme/antievilmaid_secret.png
    fi
fi

if ! getarg rd.antievilmaid.dontforcestickremoval; then
    # Pause progress till the user remove the stick
    [ -x /bin/plymouth ] && /bin/plymouth pause-progress

    message "Please remove your Anti Evil Maid stick and continue the boot process only if your secret appears on the screen..."
    while [ -b /dev/antievilmaid ]; do
        sleep 0.1
    done

    if [ -x /bin/plymouth ]; then
        # hide the secret and our other messages
        for m in "${PLYMOUTH_MESSAGES[@]}"; do
            plymouth hide-message --text="$m"
        done
        /bin/plymouth unpause-progress
    fi
fi
rm -f /tmp/unsealed-secret.txt
