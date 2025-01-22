#!/usr/bin/env -S  bash  -xe

dnf update -y

dnf config-manager --enable crb
dnf config-manager --enable devel

dnf groupinstall -y 'Development Tools'

# Install Lustre/ZFS dependencies and tools
dnf install -y --nogpgcheck libnl3-devel libmount-devel \
    wget ncurses-devel bc dwarves kernel kernel-devel openssl-devel \
    binutils-devel lsof crash kexec-tools perf psmisc e2fsprogs-devel \
    elfutils-libelf-devel libudev-devel libattr-devel libaio-devel libuuid-devel \
    libblkid-devel libffi-devel ncompress python3-cffi python3-devel \
    python3-packaging python3-docutils kernel-rpm-macros kernel-abi-stablelists  \
    libyaml-devel keyutils-libs-devel 


dnf install -y  elfutils-devel libselinux-devel  dnf-plugins-core bison\
    flex  json-c-devel redhat-lsb libssh-devel\
    libtirpc-devel    texinfo texinfo-tex \
    audit-libs-devel  kabi-dw newt-devel\
    numactl-devel  pciutils-devel   xmlto \
    libcap-devel libcap-ng-devel llvm-toolset opencsd-devel \
    ccache pdsh


# for Kernel RPM build
dnf install -y bpftool java-devel libbabeltrace-devel libbpf-devel libmnl-devel net-tools rsync \
    WALinuxAgent-cvm centos-sb-certs  gcc-plugin-devel   system-sb-certs  systemd-boot-unsigned  tpm2-tools glibc-static

