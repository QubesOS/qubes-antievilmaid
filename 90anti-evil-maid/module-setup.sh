#!/bin/bash

check() {
    which tpm_unsealdata tpm2_unseal  >/dev/null 2>&1 || return 1
}


#depends() {
#}


installkernel() {
    instmods tpm_tis tpm_crb
}

install() {
    inst_script "$moddir"/anti-evil-maid-unseal /sbin/anti-evil-maid-unseal
    inst_script "$moddir"/anti-evil-maid-check-mount-devs /sbin/anti-evil-maid-check-mount-devs

    inst $systemdsystemunitdir/cryptsetup-pre.target

    dracut_install \
        /usr/sbin/anti-evil-maid-lib* \
        base32 \
        blockdev \
        clear \
        cryptsetup \
        cut \
        date \
        file \
        /usr/share/misc/magic \
        grep \
        head \
        install \
        killall \
        lsblk \
        oathtool \
        printf \
        scrypt \
        sed \
        seq \
        sha1sum \
        sort \
        tail \
        tcsd \
        tcsd_changer_identify \
        tee \
        tpm_id \
        tpm_nvinfo \
        tpm_nvread \
        tpm_nvread_stdout \
        tpm_pcr_extend \
        tpm_sealdata \
        tpm_unsealdata \
        tpm_z_srk \
        tr \
        uniq \
        wc \
        xargs \
        xxd

    # TPM2-related:
    # tpm2-tools
    dracut_install \
        tpm2_changeauth \
        tpm2_create \
        tpm2_createprimary \
        tpm2_evictcontrol \
        tpm2_encryptdecrypt \
        tpm2_flushcontext \
        tpm2_load \
        tpm2_nvdefine \
        tpm2_nvread \
        tpm2_nvreadpublic \
        tpm2_nvundefine \
        tpm2_nvwrite \
        tpm2_nvwritelock \
        tpm2_pcrextend \
        tpm2_pcrread \
        tpm2_policycommandcode \
        tpm2_startauthsession \
        tpm2_unseal
    # such tpm2-tss libraries must be listed explicitly because they are
    # discovered at runtime instead of being linked to during build
    dracut_install \
        /usr/lib64/libtss2-tcti-device.so.0*

    dracut_install \
        $systemdsystemunitdir/anti-evil-maid-unseal.service \
        $systemdsystemunitdir/anti-evil-maid-check-mount-devs.service \
        $systemdsystemunitdir/initrd.target.wants/anti-evil-maid-unseal.service \
        $systemdsystemunitdir/initrd.target.requires/anti-evil-maid-check-mount-devs.service

    # all this crap below is needed for tcsd to start properly...
    dracut_install ip
    inst_simple "$moddir"/hosts /etc/hosts

    touch "$initdir/etc/"{passwd,shadow,group}
    chmod 0644 "$initdir/etc/"{passwd,group}
    chmod 0640 "$initdir/etc/shadow"
    for name in root tss; do
        for file in /etc/{passwd,group}; do
            if ! grep -q "^$name:" "$initdir/$file"; then
                grep "^$name:" "$file" >> "$initdir/$file"
            fi
        done

        if ! grep -q "^$name:" "$initdir/etc/shadow"; then
            echo "$name:*:::::::" >> "$initdir/etc/shadow"
        fi
    done
}
