%{!?version: %define version %(cat version)}

%define _builddir %(pwd)
Name:		anti-evil-maid-trustedgrub
Version:	%{version}
Release:	1%{dist}
Summary:	TrustedGRUB for Anti Evil Maid.

Vendor:		Invisible Things Lab
License:	GPL
URL:            http://trustedgrub.sf.net
ExclusiveArch:  x86_64
BuildRequires:  glibc(x86-32) glibc-devel(x86-32) libgcc(x86-32)
Source:		TrustedGRUB-%{version}.tar.gz
Patch0:		trustedgrub-automake-1.12.patch


%description
TrustedGRUB for Anti Evil Maid.

%prep 
%setup -n TrustedGRUB-%{version}
%patch0 -p0

%build
./build_tgrub.sh

%install

mkdir -p $RPM_BUILD_ROOT/usr/lib/antievilmaid/trustedgrub/
cp TrustedGRUB-%{version}/stage1/stage1 $RPM_BUILD_ROOT/usr/lib/antievilmaid/trustedgrub/
cp TrustedGRUB-%{version}/stage2/stage2 $RPM_BUILD_ROOT/usr/lib/antievilmaid/trustedgrub/
cp TrustedGRUB-%{version}/grub/grub $RPM_BUILD_ROOT/usr/lib/antievilmaid/trustedgrub/

%clean
rm -rf $RPM_BUILD_ROOT;

%files
/usr/lib/antievilmaid/trustedgrub
