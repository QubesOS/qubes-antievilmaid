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
    inst_script "$moddir"/anti-evil-maid /sbin/anti-evil-maid
    inst_script "$moddir"/anti-evil-maid-check-mount-devs /sbin/anti-evil-maid-check-mount-devs

    # TPM software stack
    dracut_install \
        clear \
        cut \
        file \
        /usr/share/misc/magic \
        grep \
        sha1sum \
        sort \
        tcsd \
        tpm_pcr_extend \
        tpm_unsealdata \
        wc

    dracut_install \
        $systemdsystemunitdir/anti-evil-maid-console.service \
        $systemdsystemunitdir/anti-evil-maid-plymouth.service \
        $systemdsystemunitdir/anti-evil-maid-check-mount-devs.service \
        $systemdsystemunitdir/initrd.target.wants/anti-evil-maid-console.service \
        $systemdsystemunitdir/initrd.target.wants/anti-evil-maid-plymouth.service \
        $systemdsystemunitdir/initrd.target.requires/anti-evil-maid-check-mount-devs.service

    # all this crap below is needed for tcsd to start properly...
    dracut_install ip
    inst_simple "$moddir"/hosts /etc/hosts
    inst_simple "$moddir"/passwd /etc/passwd
    inst_simple "$moddir"/shadow /etc/shadow
}
