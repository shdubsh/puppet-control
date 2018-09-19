# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

config = YAML.load(File.open('./Vagrant_config.yaml').read)
default_domain = 'test'
hosts = config['hosts']

Vagrant.configure("2") do |config|
  config.vm.define "puppet" do |puppet|
    puppet.vm.box = "debian/stretch64"
    puppet.vm.hostname = "puppet" + '.' + default_domain
    puppet.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: 3
    puppet.vm.provider :libvirt do |libvirt|
      libvirt.cpus = 4
      libvirt.memory = 2048
    end
    puppet.vm.provision :shell do |s|
      s.path = './provision.sh'
    end
  end

  hosts.each_key do |host|
    config.vm.define host do |c|
      c.vm.hostname = host + '.' + default_domain
      c.vm.box = hosts[host]['box']
      c.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_version: 3
      c.vm.provider :libvirt do |libvirt|
        libvirt.cpus = hosts[host]['cores'] == nil ? 2 : hosts[host]['cores']
        libvirt.memory = hosts[host]['memory'] == nil ? 1024 : hosts[host]['memory']
      end
      c.vm.provision :shell do |s|
        s.path = './provision.sh'
      end
    end
  end



  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
