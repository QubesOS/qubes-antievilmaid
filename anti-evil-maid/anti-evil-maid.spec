%define name anti-evil-maid
%define subdir %{?qubes_builder:%{name}/}
%define _builddir %(pwd)/%{subdir}
%{!?version: %define version %(cat %{subdir}version)}

Name:		%{name}
Version:	%{version}
Release:	1%{?dist}
Summary:    	Anti Evil Maid for initramfs-based systems.
Requires:	anti-evil-maid-dracut parted tboot trousers tpm-tools
Vendor:		Invisible Things Lab
License:	GPL
URL:		http://www.qubes-os.org

%description
Anti Evil Maid for initramfs-based systems.

%install

mkdir -p $RPM_BUILD_ROOT/usr/lib/antievilmaid/
cp antievilmaid_install $RPM_BUILD_ROOT/usr/lib/antievilmaid/
cp README $RPM_BUILD_ROOT/usr/lib/antievilmaid/

mkdir -p $RPM_BUILD_ROOT/etc/grub.d/
cp 19_linux_xen_tboot $RPM_BUILD_ROOT/etc/grub.d/

%files
/usr/lib/antievilmaid/antievilmaid_install
/usr/lib/antievilmaid/README
/etc/grub.d/19_linux_xen_tboot
