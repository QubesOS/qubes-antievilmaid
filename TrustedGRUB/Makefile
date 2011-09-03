RPMS_DIR=../rpm/
VERSION := $(shell cat version)
SRC_FILE=TrustedGRUB-$(VERSION).tar.gz
SRC_URL=http://sourceforge.net/projects/trustedgrub/files/TrustedGRUB-$(VERSION)/TrustedGRUB-$(VERSION).tar.gz

WORKDIR := $(shell pwd)
SPECDIR ?= $(WORKDIR)
BUILDDIR ?= $(WORKDIR)
RPMDIR ?= $(WORKDIR)/../rpm
SOURCEDIR := $(WORKDIR)

RPM_DEFINES := --define "_sourcedir $(SOURCEDIR)" \
		--define "_specdir $(SPECDIR)" \
		--define "_builddir $(BUILDDIR)" \
		--define "_srcrpmdir $(SRCRPMDIR)" \
		--define "_rpmdir $(RPMDIR)" \
		--define "version $(VERSION)" \


all: get-sources verify-sources rpms

get-sources: $(SRC_FILE)

$(SRC_FILE):
	@echo -n "Downloading TrustedGRUB sources..."
	@wget -q $(SRC_URL)
	@echo "OK."

verify-sources:
	@sha1sum -c checksums.sha1

rpms:
	rpmbuild $(RPM_DEFINES) -bb trustedgrub.spec

