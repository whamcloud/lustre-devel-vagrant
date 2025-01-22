#!/usr/bin/env -S bash -exv

OS_VER="9.4"

# lock image to specific release

echo $OS_VER > /etc/yum/vars/lockedver

# These repo files have been modified to use the vault url and $lockedver
cp /vagrant/repos/rocky9/rocky.repo /etc/yum.repos.d/rocky.repo
cp /vagrant/repos/rocky9/rocky-extras.repo /etc/yum.repos.d/rocky-extras.repo
cp /vagrant/repos/rocky9/rocky-devel.repo  /etc/yum.repos.d/rocky-devel.repo


