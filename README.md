# Lustre Development Environment

This vagrant configuration creates Lustre development environment based on the master branch. This provides new virtual machine running on new patched kernel, the kernel source tree, all dependencies installed, and a
lustre_release repo ready to be configured and compiled. (Or optionally
already compiled and installed.)

N.B. One of kernel patches,
`block-integrity-allow-optional-integrity-functions-rhel9.3.patch` is currently
disabled as it does not apply.

## Notes

- The base distribution is locked to 9.4 by hardcoding the 9.4 URLs in
  the repo files. The version numbers are mostly parameterized in
  variables so support for multiple  os releases should be straightforward with a
  refactor.
- The setup process downloads a lustre repo and a kernel source rpm. This
  could be optimized to use local resources.
- The main directory in this repo is shared with the VM with nfs, and
  this requires a user password during setup. This is not required and
  can be disabled or customized.

## How To Use

### Install vagrant

   [Download Vagrant](https://learn.hashicorp.com/tutorials/vagrant/getting-started-install?in=vagrant/getting-started)

### Install libvirt

- RHEL/Rocky

  ```sh
  dnf install -y libvirt libvirt-client libvirt-devel vagrant qemu-kvm libvirt-daemon-kvm
  ```

- Ubuntu

  ```sh
  apt install qemu-kvm libvirt-daemon-system
  sudo adduser $USER libvirt
  ```
  
### Install libvirt plugin for Vagrant

```sh
   vagrant plugin install vagrant-libvirt
```

### Start VM

```sh
cd lustre-devel-vagrant
export VAGRANT_DEFAULT_PROVIDER=libvirt
vagrant up
```

The initial setup will take a while as dependencies are installed and a new kernel is built and installed.

### After the VM is up

Once `vagrant up` completes successfully, then you need to restart the VM so it is running the new kernel.

```sh
vagrant reload
```

At this point you can compile and install lustre modules with:

```sh
vagrant provision --provision-with=build-lustre
```

Alternatively, you can login with `vagrant ssh` and build Lustre
manually. The lustre source is in
`~/src/lustre-release`, and the path to the kernel source is
`/home/vagrant/kernel/rpmbuild/BUILD/kernel-5.14.0-427.42.1.el9_4/linux-5.14.0-427.42.1_lustre.el9.x86_64`.

Install Rust development tools with: `vagrant provision --provision-with=rust`

The setup and kernel building is from the
[Walk-thru Build Lustre Master on Rocky
8.7](https://wiki.whamcloud.com/pages/viewpage.action?pageId=258179277)
wiki page.
