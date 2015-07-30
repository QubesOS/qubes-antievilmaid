ifeq ($(PACKAGE_SET),dom0)
    RPM_SPEC_FILES := \
        anti-evil-maid/anti-evil-maid.spec \
        tpm-extra/tpm-extra.spec \
        trousers-changer/trousers-changer.spec
endif
