#!/usr/bin/env -S bash -evx

OS_VER="9.4"
SHORT_OS="el9"

KVER_BASE="5.14"
KVER="${KVER_BASE}.0"
KVER_FULL="${KVER}-427.42.1"

KVER_RPM="${KVER_FULL}.el$(echo ${OS_VER} | tr . _ )"

LUSTRE_DIR=~/src/lustre-release


if uname -r | grep lustre > /dev/null; then
    KERNEL_NAME=linux-${KVER_FULL}_lustre.${SHORT_OS}.$(uname -m)
else
    KERNEL_NAME=linux-${KVER_FULL}.${SHORT_OS}.$(uname -m)
fi    

cd $LUSTRE_DIR
[ -e Makefile ] && make clean
./configure --with-linux=$HOME/kernel/rpmbuild/BUILD/kernel-${KVER_RPM}/$KERNEL_NAME

make -j4
sudo make install
sudo depmod -a







