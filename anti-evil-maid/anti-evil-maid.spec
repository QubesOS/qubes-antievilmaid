%define name anti-evil-maid
%define subdir %{?qubes_builder:%{name}/}
%define _builddir %(pwd)/%{subdir}
%{!?version: %define version %(cat %{subdir}version)}

Name:		%{name}
Version:	%{version}
Release:	1%{?dist}
Summary:    	Anti Evil Maid for initramfs-based systems.
Requires:	dracut parted tboot tpm-tools tpm-extra trousers-changer systemd >= 208-19
Obsoletes:	anti-evil-maid-dracut
Vendor:		Invisible Things Lab
License:	GPL
URL:		http://www.qubes-os.org

%description
Anti Evil Maid for initramfs-based systems.

%install

mkdir -p $RPM_BUILD_ROOT/usr/sbin
cp antievilmaid_boilerplate $RPM_BUILD_ROOT/usr/sbin
cp antievilmaid_install $RPM_BUILD_ROOT/usr/sbin
cp antievilmaid_removable $RPM_BUILD_ROOT/usr/sbin
cp antievilmaid_seal $RPM_BUILD_ROOT/usr/sbin

mkdir -p $RPM_BUILD_ROOT/usr/share/doc/antievilmaid
cp README $RPM_BUILD_ROOT/usr/share/doc/antievilmaid

mkdir -p $RPM_BUILD_ROOT/etc
cp antievilmaid.conf $RPM_BUILD_ROOT/etc

mkdir -p $RPM_BUILD_ROOT/etc/grub.d/
cp 19_linux_xen_tboot $RPM_BUILD_ROOT/etc/grub.d/

mkdir -p $RPM_BUILD_ROOT/mnt/antievilmaid
mkdir -p $RPM_BUILD_ROOT/var/lib/antievilmaid

mkdir -p $RPM_BUILD_ROOT/etc
cp -r dracut.conf.d $RPM_BUILD_ROOT/etc

mkdir -p $RPM_BUILD_ROOT/usr/lib/dracut/modules.d
cp -r 90anti-evil-maid $RPM_BUILD_ROOT/usr/lib/dracut/modules.d/

mkdir -p $RPM_BUILD_ROOT/usr/lib
cp -r systemd $RPM_BUILD_ROOT/usr/lib

%files
/usr/sbin/antievilmaid_boilerplate
/usr/sbin/antievilmaid_install
/usr/sbin/antievilmaid_removable
/usr/sbin/antievilmaid_seal
/usr/share/doc/antievilmaid/README
/usr/lib/systemd/system/anti-evil-maid-seal.service
/usr/lib/systemd/system/tcsd.service.d/antievilmaid_seal.conf
/usr/lib/systemd/system/sysinit.target.wants/anti-evil-maid-seal.service
/etc/antievilmaid.conf
/etc/grub.d/19_linux_xen_tboot
%dir /mnt/antievilmaid
%dir /var/lib/antievilmaid

/etc/dracut.conf.d/anti-evil-maid.conf
/usr/lib/dracut/modules.d/90anti-evil-maid
/usr/lib/systemd/system/anti-evil-maid-unseal.service
/usr/lib/systemd/system/anti-evil-maid-check-mount-devs.service
/usr/lib/systemd/system/initrd.target.wants/anti-evil-maid-unseal.service
/usr/lib/systemd/system/initrd.target.requires/anti-evil-maid-check-mount-devs.service
