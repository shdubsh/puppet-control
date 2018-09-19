
# Vagrant puppetmaster
node 'puppet.test' {
  include base
  include profile::puppetmaster
  include profile::puppetmaster_vagrant
}

node default {
  include base

  $pieces = split($trusted['certname'], '[.]')

  case count($pieces) {
    3: {
      $prefix = $pieces[0]
      $datacenter = $pieces[1]
      $tld = $pieces[2]
    }
    2: {
      $prefix = $pieces[0]
      $tld = $pieces[1]
    }
    default: {
      fail("Unable to determine role from certname: ${trusted['certname']}")
    }
  }

  $role = hiera("prefix::${prefix}::role", 'unassigned')

  role::assign { $role:
    prefix => $prefix,
    datacenter => $datacenter,
    tld => $tld,
    role => $role
  }
}
