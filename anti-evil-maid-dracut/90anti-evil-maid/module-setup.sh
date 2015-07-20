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

inst_rules "$moddir/69-anti-evil-maid.rules"
inst_script "$moddir"/anti-evil-maid.sh /sbin/anti-evil-maid

# TPM software stack
dracut_install -o \
tpm_unsealdata \
tpm_version \
tpm_pcr_extend \
sha1sum \
cut \
sort \
tcsd \
file \
clear \
/usr/share/misc/magic \
grep

dracut_install -o \
$systemdsystemunitdir/anti-evil-maid-console.service \
$systemdsystemunitdir/anti-evil-maid-plymouth.service \
$systemdsystemunitdir/initrd.target.wants/anti-evil-maid-console.service \
$systemdsystemunitdir/initrd.target.wants/anti-evil-maid-plymouth.service

# all this crap below is needed for tcsd to start properly...
dracut_install -o ip
inst_simple "$moddir"/hosts /etc/hosts
inst_simple "$moddir"/passwd /etc/passwd
inst_simple "$moddir"/shadow /etc/shadow

}
