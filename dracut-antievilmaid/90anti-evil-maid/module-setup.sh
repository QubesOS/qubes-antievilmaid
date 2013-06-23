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
inst_script "$moddir"/cryptroot-ask.antievilmaid /sbin/cryptroot-ask.antievilmaid
inst_hook cmdline 90 "$moddir/parse-anti-evil-maid.sh"

# TPM software stack
dracut_install -o \
tpm_unsealdata \
inst tpm_version \
inst tcsd \
inst file \
inst /usr/share/misc/magic \
inst grep

# all this crap below is needed for tcsd to start properly...
dracut_install -o ip
inst_simple "$moddir"/hosts /etc/hosts
inst_simple "$moddir"/passwd /etc/passwd
inst_simple "$moddir"/shadow /etc/shadow

}
