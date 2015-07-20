%define name tpm-extra
%define subdir %{?qubes_builder:%{name}/}
%define _builddir %(pwd)/%{subdir}
%{!?version: %define version %(cat %{subdir}version)}

Name:		%{name}
Version:	%{version}
Release:	1%{?dist}
Summary:	Command line tool for TPM PCR Extend operation

Group:		System
License:	GPL
URL:		https://www.qubes-os.org/

BuildRequires:	trousers-devel
Requires:	trousers

%description
Additional tools not included in tpm-tools package. Currently only one:
tpm_pcr_extend.

%prep


%build
gcc tpm_pcr_extend.c -Wall -Wextra -Werror -O2 -ltspi -o tpm_pcr_extend

%install
install -D tpm_pcr_extend %{buildroot}/usr/bin/tpm_pcr_extend


%files
/usr/bin/tpm_pcr_extend


%changelog
