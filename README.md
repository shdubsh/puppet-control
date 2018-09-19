Puppet Control Repo
===

Warning
---
This code is in early development.  Things could change at any time.

Requirements
---
* Libvirt (tested 4.1.0)
* Vagrant (tested 2.0.2)
* librarian-puppet-simple (tested 0.0.5)

Usage
---
In the repo directory, start the puppet server:
```bash
librarian-puppet install
vagrant up puppet
vagrant ssh puppet
kickstartpuppet
```

For other hosts:
```bash
vagrant up example
vagrant ssh example
runpuppet
```

Additional Hosts
---
Vagrant_config.yaml
```yaml
# -*- mode: yaml -*-
# vi: set ft=yaml :

---
  hosts:
    example:
      box: 'debian/stretch64'
      cores: 2
      memory: 1024
```

TODO
---
* VirtualBox Support.
* DNS and DHCP currently rely on libvirt configuring DNSmasq correctly.  For Vagrant, this should be a service on the puppet master.
* Linter and syntax checks.
* Secrets management.
* r10k environments
