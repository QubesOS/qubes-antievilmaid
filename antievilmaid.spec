%{!?version: %define version %(cat version)}

Name:		anti-evil-maid
Version:	%{version}
Release:	1%{?dist}
Summary:    	Anti Evil Maid for initramfs-based systems.
Requires:	anti-evil-maid-dracut parted tboot trousers tpm-tools
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

mkdir -p $RPM_BUILD_ROOT/etc/grub.d/
cp 40_linux_xen_tboot $RPM_BUILD_ROOT/etc/grub.d/

%files
/usr/lib/antievilmaid/antievilmaid_install
/usr/lib/antievilmaid/README
/etc/grub.d/40_linux_xen_tboot
