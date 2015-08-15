#!/bin/bash

check() {
    which tpm_unsealdata  >/dev/null 2>&1 || return 1
}


#depends() {
#}


installkernel() {
    instmods tpm_tis
}

install() {
    inst_script "$moddir"/anti-evil-maid-unseal /sbin/anti-evil-maid-unseal
    inst_script "$moddir"/anti-evil-maid-check-mount-devs /sbin/anti-evil-maid-check-mount-devs

    inst $systemdsystemunitdir/cryptsetup-pre.target

    dracut_install \
        /usr/sbin/anti-evil-maid-lib \
        clear \
        cut \
        file \
        /usr/share/misc/magic \
        grep \
        head \
        install \
        killall \
        lsblk \
        printf \
        sha1sum \
        sha256sum \
        sort \
        tail \
        tcsd \
        tcsd_changer_identify \
        tee \
        tpm_getpubek \
        tpm_id \
        tpm_pcr_extend \
        tpm_resetdalock \
        tpm_sealdata \
        tpm_unsealdata \
        tpm_z_srk \
        wc \
        xargs

    dracut_install \
        $systemdsystemunitdir/anti-evil-maid-unseal.service \
        $systemdsystemunitdir/anti-evil-maid-check-mount-devs.service \
        $systemdsystemunitdir/initrd.target.wants/anti-evil-maid-unseal.service \
        $systemdsystemunitdir/initrd.target.requires/anti-evil-maid-check-mount-devs.service

    # all this crap below is needed for tcsd to start properly...
    dracut_install ip
    inst_simple "$moddir"/hosts /etc/hosts
    inst_simple "$moddir"/passwd /etc/passwd
    inst_simple "$moddir"/shadow /etc/shadow
    inst_simple "$moddir"/shadow /etc/group
}
