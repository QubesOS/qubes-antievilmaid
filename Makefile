RPMS_DIR=rpm/
VERSION := $(shell cat version)

all:	\
	$(RPMS_DIR)/x86_64/anti-evil-maid-$(VERSION)*.rpm \
	$(RPMS_DIR)/x86_64/anti-evil-maid-dracut-$(VERSION)*.rpm \

rpms-dom0: all

rpms-vm:

$(RPMS_DIR)/x86_64/anti-evil-maid-$(VERSION)*.rpm :
	rpmbuild --define "_rpmdir $(RPMS_DIR)" -bb antievilmaid.spec

$(RPMS_DIR)/x86_64/anti-evil-maid-dracut-$(VERSION)*.rpm :
	cd dracut-antievilmaid && make rpms

update-repo-current:
	ln -f $(RPMS_DIR)/x86_64/*.rpm ../yum/current-release/current/dom0/rpm/

update-repo-current-testing:
	ln -f $(RPMS_DIR)/x86_64/*.rpm ../yum/current-release/current-testing/dom0/rpm/


clean:
