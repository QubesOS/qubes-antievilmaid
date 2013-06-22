%{!?version: %define version %(cat version)}

%if 0%{?qubes_builder}
%define version %(cat dracut-antievilmaid/version)
%define _builddir %(pwd)/dracut-antievilmaid
%else
%define _builddir %(pwd)
%endif

Name:		anti-evil-maid-dracut
Version:	%{version}
Release:	1%{?dist}
Summary:    	Dracut module and conf file to enable Anti Evil Maid support.
Requires:	dracut trousers tpm-tools

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

%files
/etc/dracut.conf.d/anti-evil-maid.conf
/usr/lib/dracut/modules.d/90anti-evil-maid

