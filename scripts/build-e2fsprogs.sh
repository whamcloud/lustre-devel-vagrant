#!/usr/bin/env -S  bash -ex


# Checkout and build e2fsprogs
mkdir -p  ~/src
cd ~/src

git clone "https://review.whamcloud.com/tools/e2fsprogs" e2fsprogs
cd e2fsprogs
git checkout v1.47.1-wc1
./configure --with-root-prefix=/usr --enable-elf-shlibs --disable-uuidd --disable-fsck \
	    --disable-e2initrd-helper --disable-libblkid --disable-libuuid --enable-quota --disable-fuse2fs
make -j4
sudo make install
