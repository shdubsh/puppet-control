#!/bin/bash
host -W 5 puppet.test
if [ $? == 1 ]; then
# Stop systemd from managing resolv.conf
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
sudo kill $(pgrep dhclient)
rm /etc/resolve.conf
printf "nameserver $(cat /vagrant/.vagrant/machines/puppet/*/ip || echo 1.1.1.1)\nsearch test\n" | sudo tee /etc/resolv.conf
fi
sudo /opt/puppetlabs/bin/puppet agent -t --environment production $1
