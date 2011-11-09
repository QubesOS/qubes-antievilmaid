RPMS_DIR=rpm/
VERSION := $(shell cat version)
VERSION_TRUSTEDGRUB := $(shell cat TrustedGRUB/version)

all:	\
	$(RPMS_DIR)/x86_64/anti-evil-maid-$(VERSION)*.rpm \
	$(RPMS_DIR)/x86_64/anti-evil-maid-dracut-$(VERSION)*.rpm \
	$(RPMS_DIR)/x86_64/anti-evil-maid-trustedgrub-$(VERSION_TRUSTEDGRUB)*.rpm \


$(RPMS_DIR)/x86_64/anti-evil-maid-$(VERSION)*.rpm :
	rpmbuild --define "_rpmdir $(RPMS_DIR)" -bb antievilmaid.spec

$(RPMS_DIR)/x86_64/anti-evil-maid-dracut-$(VERSION)*.rpm :
	cd dracut-antievilmaid && make rpms

$(RPMS_DIR)/x86_64/anti-evil-maid-trustedgrub-$(VERSION_TRUSTEDGRUB)*.rpm :
	cd TrustedGRUB && make all

clean:
