%define name anti-evil-maid-dracut
%define subdir %{?qubes_builder:%{name}/}
%define _builddir %(pwd)/%{subdir}
%{!?version: %define version %(cat %{subdir}version)}

Name:		%{name}
Version:	%{version}
Release:	1%{?dist}
Summary:    	Dracut module and conf file to enable Anti Evil Maid support.
Requires:	dracut trousers tpm-tools tpm-extra

Vendor:		Invisible Things Lab
License:	GPL
URL:		http://www.qubes-os.org

%description
Dracut module and conf file to enable Anti Evil Maid support.

%install

mkdir -p $RPM_BUILD_ROOT/etc/dracut.conf.d
cp anti-evil-maid.conf $RPM_BUILD_ROOT/etc/dracut.conf.d/

mkdir -p $RPM_BUILD_ROOT/usr/lib/dracut/modules.d
cp -r 90anti-evil-maid $RPM_BUILD_ROOT/usr/lib/dracut/modules.d/

mkdir -p $RPM_BUILD_ROOT/usr/lib/systemd/system/
cp anti-evil-maid-console.service $RPM_BUILD_ROOT/usr/lib/systemd/system/
cp anti-evil-maid-plymouth.service $RPM_BUILD_ROOT/usr/lib/systemd/system/

mkdir -p $RPM_BUILD_ROOT/usr/lib/systemd/system/initrd.target.wants
cd $RPM_BUILD_ROOT/usr/lib/systemd/system/initrd.target.wants
ln -s ../anti-evil-maid-console.service .
ln -s ../anti-evil-maid-plymouth.service .

%files
/etc/dracut.conf.d/anti-evil-maid.conf
/usr/lib/dracut/modules.d/90anti-evil-maid
/usr/lib/systemd/system/anti-evil-maid-console.service
/usr/lib/systemd/system/anti-evil-maid-plymouth.service
/usr/lib/systemd/system/initrd.target.wants/anti-evil-maid-console.service
/usr/lib/systemd/system/initrd.target.wants/anti-evil-maid-plymouth.service
