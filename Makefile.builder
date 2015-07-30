ifeq ($(PACKAGE_SET),dom0)
    RPM_SPEC_FILES := \
        anti-evil-maid/anti-evil-maid.spec \
        anti-evil-maid-dracut/anti-evil-maid-dracut.spec \
        tpm-extra/tpm-extra.spec \
        trousers-changer/trousers-changer.spec
endif
