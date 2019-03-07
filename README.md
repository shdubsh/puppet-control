Puppet Control Repo
===

Warning
---
This code is in early development.  Things could change or break at any time.

Requirements
---
* Libvirt (tested 4.1.0) or VirtualBox (tested 5.2.18)
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
Config.yaml
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
* Centralize DNS configuration and enable custom domains
* Linter and syntax checks.
* Secrets management.
* r10k environments
