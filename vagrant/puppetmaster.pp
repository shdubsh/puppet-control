node default {
  include profile::vagrant_puppetmaster
  $role = 'puppetmaster'
  $datacenter = 'test'
}