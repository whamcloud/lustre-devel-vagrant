#!/usr/bin/env -S bash -exv

OS_VER="9.4"
SHORT_OS="el9"

KVER_BASE="5.14"
KVER="${KVER_BASE}.0"
KVER_FULL="${KVER}-427.42.1"

KVER_RPM="${KVER_FULL}.el$(echo ${OS_VER} | tr . _ )"

: ${LUSTRE_DIR:=~/src/lustre-release}


# cd $HOME && mkdir -p kernel/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
mkdir -p ~/kernel
cd ~/kernel && echo '%_topdir %(echo $HOME)/kernel/rpmbuild' > ~/.rpmmacros

# Not needed since we're building a new kernel
# sudo dnf install -y --enablerepo='baseos-debug*' kernel-debuginfo

# Kernel source rpm
rpm -ivh https://dl.rockylinux.org/vault/rocky/${OS_VER}/BaseOS/source/tree/Packages/k/kernel-${KVER_RPM}.src.rpm

cd ~/kernel/rpmbuild
rpmbuild -bp --target=$(uname -m) ./SPECS/kernel.spec

LUSTRE_CONFIG=$LUSTRE_DIR/lustre/kernel_patches/kernel_configs/kernel-${KVER}-${KVER_BASE}-rhel${OS_VER}-$(uname -m).config

cd BUILD/kernel-${KVER_RPM}/linux-${KVER_FULL}.${SHORT_OS}.$(uname -m)/
cp configs/kernel-${KVER}-$(uname -m).config $LUSTRE_CONFIG


#
# Apply lustre patches to kernel
#

AGGREGATE_PATCH=~/lustre-kernel-$(uname -m)-lustre.patch
> $AGGREGATE_PATCH

cd ~/src/lustre-release/lustre/kernel_patches/series && 
for patch in $(grep -v -e "block-integrity"  "${KVER_BASE}-rhel${OS_VER}.series"); do 
     patch_file="${HOME}/src/lustre-release/lustre/kernel_patches/patches/${patch}"
     cat "${patch_file}" >> $AGGREGATE_PATCH
done

cp $AGGREGATE_PATCH ~/kernel/rpmbuild/SOURCES/patch-${KVER}-lustre.patch

#
# Add patch to the  kernel.spec 
#
 sed -i.inst -e '/^    find $RPM_BUILD_ROOT\/lib\/modules\/$KernelVer/a\
    cp -a fs/ext4/* $RPM_BUILD_ROOT/lib/modules/$KernelVer/build/fs/ext4\
    rm -f $RPM_BUILD_ROOT/lib/modules/$KernelVer/build/fs/ext4/ext4-inode-test*' \
-e '/^# empty final patch to facilitate testing of kernel patches/i\
Patch99995: patch-%{version}-lustre.patch' \
-e '/^ApplyOptionalPatch linux-kernel-test.patch/i\
ApplyOptionalPatch patch-%{version}-lustre.patch' \
   ~/kernel/rpmbuild/SPECS/kernel.spec

# Some versions touch this so leaving this here for completeness
cp $LUSTRE_CONFIG ~/kernel/rpmbuild/SOURCES/kernel-$(uname -m).config 

#
# Build kernel

cd ~/kernel/rpmbuild

export buildid="_lustre"

rpmbuild -ba --with firmware --target $(uname -m) --with baseonly \
     --without kabichk --define "buildid ${buildid}" \
     ~/kernel/rpmbuild/SPECS/kernel.spec

cd ~/kernel/rpmbuild/RPMS/$(uname -m )/
sudo rpm -Uvh --replacepkgs --force kernel-*.rpm

echo "Reboot (or vagrant reload)  to switch to the Lustre kernel."


