
$site = $facts['ipaddress'] ? {
  /^208\.80\.15[23]\./                                      => 'codfw',
  /^208\.80\.15[45]\./                                      => 'eqiad',
  /^10\.6[48]\./                                            => 'eqiad',
  /^10\.19[26]\./                                           => 'codfw',
  /^91\.198\.174\./                                         => 'esams',
  /^198\.35\.26\./                                          => 'ulsfo',
  /^10\.128\./                                              => 'ulsfo',
  /^10\.20\.0\./                                            => 'esams',
  /^103\.102\.166\./                                        => 'eqsin',
  /^10\.132\./                                              => 'eqsin',
  /^172\.16\.([0-9]|[1-9][0-9]|1([0-1][0-9]|2[0-7]))\./     => 'eqiad',
  /^172\.16\.(1(2[8-9]|[3-9][0-9])|2([0-4][0-9]|5[0-5]))\./ => 'codfw',
  default                                                   => '(undefined)'
}

# Vagrant puppetmaster
node 'puppet.test' {
  include profile::puppetmaster
  include profile::puppetmaster_vagrant
  $role = 'puppetmaster'
  $datacenter = 'test'
}

node default {

  $pieces = split($trusted['certname'], '[.]')

  case count($pieces) {
    3: {
      $prefix = $pieces[0]
      $datacenter = $pieces[1]
      $tld = $pieces[2]
    }
    2: {
      $prefix = $pieces[0]
      $datacenter = $pieces[1]
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
