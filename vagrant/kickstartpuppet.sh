#!/bin/bash

# Plant Puppet IP
if [ -d /vagrant/.vagrant/machines/puppet/libvirt ]; then
facter ipaddress > /vagrant/.vagrant/machines/puppet/libvirt/ip
fi
if [ -d /vagrant/.vagrant/machines/puppet/virtualbox ]; then
facter ipaddress > /vagrant/.vagrant/machines/puppet/virtualbox/ip
fi

# Plant zonefile generator
sudo ln -s /vagrant/vagrant/zonefile_generator.py /usr/local/bin/zonefile_generator
sudo chmod +x /usr/local/bin/zonefile_generator

# Install and configure coredns
if [ ! -f /vagrant/vagrant/coredns ]; then
wget https://github.com/coredns/coredns/releases/download/v1.4.0/coredns_1.4.0_linux_amd64.tgz -O /tmp/coredns.tgz
tar xf /tmp/coredns.tgz -C /tmp
cp /tmp/coredns /vagrant/vagrant/coredns
sudo mv /tmp/coredns /usr/bin/coredns
else
sudo cp /vagrant/vagrant/coredns /usr/bin/coredns
fi
sudo cp /vagrant/vagrant/coredns /usr/bin/coredns
sudo chmod +x /usr/bin/coredns
sudo mkdir /etc/coredns
sudo cp /vagrant/vagrant/Corefile /etc/coredns/Corefile
sudo mkdir /etc/coredns/zones

# Seed zone
python3 /usr/local/bin/zonefile_generator | sudo tee /etc/coredns/zones/test

# Enable and start coredns.  Disable systemd-resolved
sudo cp /vagrant/vagrant/coredns.service /lib/systemd/system/coredns.service
sudo useradd -s /usr/sbin/nologin -m -d /home/coredns coredns
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo systemctl enable coredns.service
sudo systemctl start coredns.service

# Use coredns instance
printf 'nameserver 127.0.0.1\nsearch test\n' | sudo tee /etc/resolv.conf

# Install, configure, and start Puppet
sudo /opt/puppetlabs/bin/puppet apply --modulepath /vagrant/modules /vagrant/vagrant/puppetmaster.pp
sudo systemctl restart puppetserver
sudo /opt/puppetlabs/bin/puppetdb ssl-setup
sudo systemctl restart puppetdb
/usr/local/bin/runpuppet

# Install clean_node
ln -s /vagrant/vagrant/clean_node.sh /usr/local/bin/clean_node
chmod +x /usr/local/bin/clean_node
echo ---------------  Puppet Kickstart Complete ---------------
