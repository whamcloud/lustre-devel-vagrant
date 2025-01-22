#!/usr/bin/env -S bash -xe

mkdir -p  ~/src

cd ~/src

# Checkout lustre 
git clone "https://review.whamcloud.com/fs/lustre-release"
cd lustre-release

# Build Lustre
sh autogen.sh
#./configure 
# make -j4
