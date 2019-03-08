#!/bin/bash

# This may not be ideal, but it resolves some issues
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

wget https://apt.puppetlabs.com/puppet5-release-stretch.deb
dpkg -i puppet5-release-stretch.deb
apt update

apt install -y puppet-agent

echo '#!/bin/bash' > /usr/local/bin/runpuppet
#echo 'sudo /opt/puppetlabs/bin/puppet agent -t --environment production $1' >> /usr/local/bin/runpuppet
echo 'bash /vagrant/vagrant/runpuppet.sh' >> /usr/local/bin/runpuppet
chmod +x /usr/local/bin/runpuppet

if [ $(hostname) == 'puppet' ]; then
echo '#!/bin/bash' > /usr/local/bin/kickstart_puppet
echo 'bash /vagrant/vagrant/kickstart_puppet.sh' >> /usr/local/bin/kickstart_puppet
chmod +x /usr/local/bin/kickstart_puppet
fi

# Vagrant dir is not available at provision time.  Helper script to load after ssh.
echo '#!/bin/bash' > /usr/local/bin/customize
echo 'bash /vagrant/vagrant/customize.sh' >> /usr/local/bin/customize
chmod +x /usr/local/bin/customize

# TODO: Modify MOTD with helpful info.
