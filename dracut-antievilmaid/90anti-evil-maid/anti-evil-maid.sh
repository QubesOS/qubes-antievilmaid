#!/bin/sh
#
# Anti Evil Maid for dracut by Invisible Things Lab
# Copyright (C) 2010 Joanna Rutkowska <joanna@invisiblethingslab.com>
#
# Mount our device, read the sealed secret blobs, initilize TPM
# and finally try to unseal the secrets and display them to the user
#


. /lib/dracut-lib.sh

if [ -d /antievilmaid ] ; then
	info "/antievilmaid already exists, skipping..."
	exit 0
fi

info "Waiting for antievilmaid boot device to become avilable..."
while ! [ -b /dev/antievilmaid ]; do
	sleep 0.1
done

info "Mouting the antievilmaid boot device..."
mkdir /antievilmaid
mount /dev/antievilmaid /antievilmaid

info "Initializing TPM..."
/sbin/modprobe tpm_tis
ip link set dev lo up
mkdir -p /var/lib/tpm/
cp /antievilmaid/antievilmaid/system.data /var/lib/tpm/
/usr/sbin/tcsd

if getarg rd.antievilmaid.png_secret; then
    TPMARGS="-o /usr/share/plymouth/themes/qubes/secret.png"
else
    TPMARGS=""
    # Disable hide-splash because it break keyboard input and the user 
    # is not able anymore to enter his passphrase or to switch back to 
    # the splash screen
    #/bin/plymouth hide-splash
fi

if ! getarg rd.antievilmaid.asksrkpass; then
    info "Using default SRK password"
    TPMARGS="$TPMARGS -z"
fi

info "Attempting to unseal the secret passphrase from the TPM..."
/bin/plymouth message --text="Attempting to unseal the secret passphrase from the TPM..."
/bin/plymouth message --text=""

if [ -f /antievilmaid/antievilmaid/sealed_secret.blob ] ; then
    UNSEALED_SECRET=`/usr/bin/tpm_unsealdata $TPMARGS -i /antievilmaid/antievilmaid/sealed_secret.blob`
    /bin/plymouth message --text="$UNSEALED_SECRET"
else
    info "No data to unseal."
    /bin/plymouth message --text="No data to unseal. Do not forget to generate a sealed_secret.blob"
fi

/bin/plymouth message --text=""
/bin/plymouth message --text="Continue the boot process only if the secret above is correct!"
/bin/plymouth message --text=""

info "Unmounting the antievilmaid device..."
umount /dev/antievilmaid

# Verify if the unsealed PNG secret seems valid and replace the lock icon
if getarg rd.antievilmaid.png_secret; then
    if file /usr/share/plymouth/themes/qubes/secret.png | grep PNG > /dev/null ; then
        cp /usr/share/plymouth/themes/qubes/secret.png /usr/share/plymouth/themes/qubes/lock.png
    fi
fi

if ! getarg rd.antievilmaid.dontforcestickremoval; then
    # Pause progress till the user remove the stick
    /bin/plymouth pause-progress

    /bin/plymouth message --text="Please remove your Anti Evil Maid stick an continue the boot process only if your secret appears on the screen..."
    while [ -b /dev/antievilmaid ]; do
	    sleep 0.1
    done

    /bin/plymouth unpause-progress
fi
