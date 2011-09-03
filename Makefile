RPMS_DIR=rpm/
VERSION := $(shell cat version)

all:	rpms
rpms:
	rpmbuild --define "_rpmdir $(RPMS_DIR)" -bb antievilmaid.spec

