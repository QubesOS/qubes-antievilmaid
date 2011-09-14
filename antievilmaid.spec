%{!?version: %define version %(cat version)}

Name:		anti-evil-maid
Version:	%{version}
Release:	1%{?dist}
Summary:    	Anti Evil Maid for initramfs-based systems.
Requires:	anti-evil-maid-dracut anti-evil-maid-trustedgrub parted
Vendor:		Invisible Things Lab
License:	GPL
URL:		http://www.qubes-os.org

%define _builddir %(pwd)

%description
Anti Evil Maid for initramfs-based systems.

%install

mkdir -p $RPM_BUILD_ROOT/usr/lib/antievilmaid/
cp antievilmaid_install $RPM_BUILD_ROOT/usr/lib/antievilmaid/
cp README $RPM_BUILD_ROOT/usr/lib/antievilmaid/

%files
/usr/lib/antievilmaid/antievilmaid_install
/usr/lib/antievilmaid/README

