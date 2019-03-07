# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

custom_config = YAML.load(File.open('vagrant/vagrant.yaml').read)
default_domain = 'test'
hosts = custom_config['hosts']
# Need vagrant-vbguest plugin to get virtualbox guest additions installed
# https://stackoverflow.com/a/51925021
# Plugins
#
# Check if the first argument to the vagrant
# command is plugin or not to avoid the loop
if ARGV[0] != 'plugin'

  # Define the plugins in an array format
  if custom_config['provider'] == 'libvirt'
    required_plugins = []
  else
    required_plugins = [
        'vagrant-vbguest'
    ]
    # https://github.com/hashicorp/vagrant/issues/3792
    # https://gist.github.com/blech75/8e0808e1982b6c605be5cad35fc13350
    vbox_version = `vboxmanage --version | cut -d '_' -f 1`.chomp
    if not File.exists?("VBoxGuestAdditions_#{vbox_version}.iso")
      system "wget https://download.virtualbox.org/virtualbox/#{vbox_version}/VBoxGuestAdditions_#{vbox_version}.iso"
    end
  end
  plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
  if not plugins_to_install.empty?

    puts "Installing plugins: #{plugins_to_install.join(' ')}"
    if system "vagrant plugin install #{plugins_to_install.join(' ')}"
      exec "vagrant #{ARGV.join(' ')}"
    else
      abort "Installation of one or more plugins has failed. Aborting."
    end
  end
end

Vagrant.configure("2") do |config|
  config.vm.define 'puppet' do |puppet|
    puppet.vm.box = 'debian/stretch64'
    puppet.vm.hostname = 'puppet' + '.' + default_domain
    if custom_config['provider'] == 'libvirt'
      puppet.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_version: 3
      puppet.vm.provider :libvirt do |libvirt|
        libvirt.cpus = 4
        libvirt.memory = 2048
      end
    else
      config.vbguest.iso_path = "./VBoxGuestAdditions_#{vbox_version}.iso"
      config.vbguest.no_remote = true
      puppet.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_udp: false
      puppet.vm.provider :virtualbox do |virtualbox|
        virtualbox.cpus = 4
        virtualbox.memory = 2048
      end
      config.vm.network :private_network, type: 'dhcp'
    end
    puppet.vm.provision :shell do |s|
      s.path = './vagrant/provision.sh'
    end
  end

  hosts.each_key do |host|
    config.vm.define host do |c|
      c.vm.hostname = host + '.' + default_domain
      c.vm.box = hosts[host]['box']
      if custom_config['provider'] == 'libvirt'
        c.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_version: 3
        c.vm.provider :libvirt do |libvirt|
          libvirt.cpus = hosts[host]['cores'] == nil ? 2 : hosts[host]['cores']
          libvirt.memory = hosts[host]['memory'] == nil ? 1024 : hosts[host]['memory']
        end
      else
        config.vbguest.no_remote = true
        c.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_udp: false, nfs_version: 3
        c.vm.provider :virtualbox do |virtualbox|
          virtualbox.cpus = hosts[host]['cores'] == nil ? 2 : hosts[host]['cores']
          virtualbox.memory = hosts[host]['memory'] == nil ? 1024 : hosts[host]['memory']
        end
      end
      c.vm.provision :shell do |s|
        s.path = './vagrant/provision.sh'
      end
      c.trigger.before :destroy do |trigger|
        trigger.info = 'Cleaning certificate from Puppet master...'
        trigger.run = { inline: 'vagrant ssh puppet -c \'clean_node ' + c.vm.hostname + '\'' }
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
