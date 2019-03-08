#!/usr/bin/env python3
import requests
import os
from datetime import datetime

PUPPET_MACHINE_DIR = '/vagrant/.vagrant/machines/puppet'
PUPPET_IP = None

A_TEMPLATE = '{0}  5 IN A {1}' # {hostname}, {ip addr}

HEADER = '''
@ 1D IN SOA ns0 hostmaster ({}
  12H     ; refresh
  2H      ; retry
  2W      ; expiry
  600     ; negative cache TTL
)
  1D  IN NS   ns0
'''

# Depends on kickstart_puppet.sh planting the puppet ip address in the machines state directory
if len(os.listdir(PUPPET_MACHINE_DIR)) > 1:
    print('; WARNING - Multiple puppet machine IP addresses found!  The first one I found might not be correct.')
for provider in os.listdir(PUPPET_MACHINE_DIR):
    if os.path.exists(os.path.join(PUPPET_MACHINE_DIR, provider, 'id')):
        with open(os.path.join(PUPPET_MACHINE_DIR, provider, 'ip')) as f:
            PUPPET_IP = f.read()
            break

print(HEADER.format(int(datetime.now().timestamp())))
print(A_TEMPLATE.format('ns0', PUPPET_IP))
print(A_TEMPLATE.format('puppet', PUPPET_IP))

try:
    raw = requests.get('http://localhost:8080/pdb/query/v4/facts').json()
    mapping = {x['certname'].split('.')[0]: x['value'] for x in raw if x['name'] == 'ipaddress'}


    for k, v in sorted(mapping.items()):
        if k == 'puppet':
            continue
        print(A_TEMPLATE.format(k, v))
except Exception:
    # Likely a problem fetching from puppetdb
    pass
