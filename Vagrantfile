Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky9"


  config.vm.provider "libvirt" do |libvirt|
    libvirt.machine_virtual_size = 128
    libvirt.memory = 8192
    libvirt.cpus = 8
#    libvirt.video_type = "vga"
#    libvirt.video_vram = "1024"
    libvirt.machine_type = "q35"
    libvirt.cpu_mode = "host-passthrough"
    libvirt.qemu_use_session = false
  end

  config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: 4

  config.vm.provision "lock-releasever",
                      type: 'shell',
                      run: 'once',
                      path: './scripts/lock-release.sh'

  config.vm.provision "install-dev-packages",
                      type: 'shell',
                      run: 'once',
                      path: './scripts/install-dev-packages.sh'

  config.vm.provision "build-e2fsprogs",
                      type: 'shell',
                      run: 'once',
                      path: './scripts/build-e2fsprogs.sh',
                      privileged: false

  config.vm.provision "setup-lustre-dev",
                      type: 'shell',
                      run: 'once',
                      path: './scripts/setup-lustre-dev.sh',
                      privileged: false

  config.vm.provision "prepare-kernel",
                      type: 'shell',
                      run: 'once',
                      path: './scripts/prepare-kernel.sh',
                      privileged: false

  config.vm.provision "build-lustre",
                      type: 'shell',
                      run: 'never',
                      path: './scripts/build-lustre.sh',
                      privileged: false

  config.vm.provision "rust",
                      type: 'shell',
                      run: 'never',
                      path: './scripts/install-rust.sh',
                      privileged: false
end
