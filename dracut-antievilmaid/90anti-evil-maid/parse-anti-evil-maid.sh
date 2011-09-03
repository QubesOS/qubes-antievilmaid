#!/bin/sh
if getarg rd.antievilmaid; then
    echo "Anti Evil Maid v1.0 (C) 2011 by Invisible Things Lab"
    # We need to hook the cryptroot ask to ensure
    # that AVM executes before the crypptroot ask prompt!
    mv /sbin/cryptroot-ask /sbin/cryptroot-ask.orig
    mv /sbin/cryptroot-ask.antievilmaid /sbin/cryptroot-ask
else
    rm -f /etc/udev/rules.d/69-anti-evil-maid.rules
fi

