%{!?version: %define version %(cat version)}

Name:		anti-evil-maid-dracut
Version:	%{version}
Release:	1%{?dist}
Summary:    	Dracut module and conf file to enable Anti Evil Maid support.
Requires:	dracut trousers tpm-tools

Vendor:		Invisible Things Lab
License:	GPL
URL:		http://www.qubes-os.org

%define _builddir %(pwd)

%description
Dracut module and conf file to enable Anti Evil Maid support.

%install

mkdir -p $RPM_BUILD_ROOT/etc/dracut.conf.d
cp anti-evil-maid.conf $RPM_BUILD_ROOT/etc/dracut.conf.d/

mkdir -p $RPM_BUILD_ROOT/usr/share/dracut/modules.d
cp -r 90anti-evil-maid $RPM_BUILD_ROOT/usr/share/dracut/modules.d/

%files
/etc/dracut.conf.d/anti-evil-maid.conf
/usr/share/dracut/modules.d/90anti-evil-maid

