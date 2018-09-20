#!/bin/bash

wget https://apt.puppetlabs.com/puppet5-release-stretch.deb
dpkg -i puppet5-release-stretch.deb
apt update

apt install -y puppet-agent

echo '#!/bin/bash' > /usr/local/bin/runpuppet
echo 'sudo /opt/puppetlabs/bin/puppet agent -t --environment production' >> /usr/local/bin/runpuppet
chmod +x /usr/local/bin/runpuppet

echo '#!/bin/bash' > /usr/local/bin/kickstartpuppet
echo 'sudo /opt/puppetlabs/bin/puppet apply --modulepath /vagrant/modules /vagrant/manifests/site.pp' >> /usr/local/bin/kickstartpuppet
echo 'sudo systemctl restart puppetserver' >> /usr/local/bin/kickstartpuppet
echo 'sudo /opt/puppetlabs/bin/puppetdb ssl-setup' >> /usr/local/bin/kickstartpuppet
echo 'sudo systemctl restart puppetdb' >> /usr/local/bin/kickstartpuppet
echo '/usr/local/bin/runpuppet' >> /usr/local/bin/kickstartpuppet
echo 'echo ################  Puppet Kickstart Complete ################' >> /usr/local/bin/kickstartpuppet
chmod +x /usr/local/bin/kickstartpuppet

# Vagrant dir is not available at provision time.  Helper script to load after ssh.
echo '#!/bin/bash' > /usr/local/bin/customize
echo 'bash /vagrant/customize.sh' >> /usr/local/bin/customize
chmod +x /usr/local/bin/customize

# TODO: Modify MOTD with helpful info.
