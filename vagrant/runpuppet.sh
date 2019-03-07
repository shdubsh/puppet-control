#!/bin/bash
host -W 5 puppet.test
if [ $? == 1 ]; then
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
printf "nameserver $(cat /vagrant/.vagrant/machines/puppet/*/ip)\nsearch test\n" | sudo tee /etc/resolv.conf
fi
sudo /opt/puppetlabs/bin/puppet agent -t --environment production $1
