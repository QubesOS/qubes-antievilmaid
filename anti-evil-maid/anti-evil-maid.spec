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
cp anti-evil-maid-boilerplate $RPM_BUILD_ROOT/usr/sbin
cp anti-evil-maid-install $RPM_BUILD_ROOT/usr/sbin
cp anti-evil-maid-removable $RPM_BUILD_ROOT/usr/sbin
cp anti-evil-maid-seal $RPM_BUILD_ROOT/usr/sbin

mkdir -p $RPM_BUILD_ROOT/usr/share/doc/anti-evil-maid
cp README $RPM_BUILD_ROOT/usr/share/doc/anti-evil-maid

mkdir -p $RPM_BUILD_ROOT/etc
cp anti-evil-maid.conf $RPM_BUILD_ROOT/etc

mkdir -p $RPM_BUILD_ROOT/etc/grub.d/
cp 19_linux_xen_tboot $RPM_BUILD_ROOT/etc/grub.d/

mkdir -p $RPM_BUILD_ROOT/mnt/anti-evil-maid
mkdir -p $RPM_BUILD_ROOT/var/lib/anti-evil-maid

mkdir -p $RPM_BUILD_ROOT/etc
cp -r dracut.conf.d $RPM_BUILD_ROOT/etc

mkdir -p $RPM_BUILD_ROOT/usr/lib/dracut/modules.d
cp -r 90anti-evil-maid $RPM_BUILD_ROOT/usr/lib/dracut/modules.d/

mkdir -p $RPM_BUILD_ROOT/usr/lib
cp -r systemd $RPM_BUILD_ROOT/usr/lib

%files
/usr/sbin/anti-evil-maid-boilerplate
/usr/sbin/anti-evil-maid-install
/usr/sbin/anti-evil-maid-removable
/usr/sbin/anti-evil-maid-seal
/usr/share/doc/anti-evil-maid/README
/usr/lib/systemd/system/anti-evil-maid-seal.service
/usr/lib/systemd/system/tcsd.service.d/anti-evil-maid-seal.conf
/usr/lib/systemd/system/sysinit.target.wants/anti-evil-maid-seal.service
/etc/anti-evil-maid.conf
/etc/grub.d/19_linux_xen_tboot
%dir /mnt/anti-evil-maid
%dir /var/lib/anti-evil-maid

/etc/dracut.conf.d/anti-evil-maid.conf
/usr/lib/dracut/modules.d/90anti-evil-maid
/usr/lib/systemd/system/anti-evil-maid-unseal.service
/usr/lib/systemd/system/anti-evil-maid-check-mount-devs.service
/usr/lib/systemd/system/initrd.target.wants/anti-evil-maid-unseal.service
/usr/lib/systemd/system/initrd.target.requires/anti-evil-maid-check-mount-devs.service
