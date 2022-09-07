default['jmh_encrypt']['lukscrypt']['physical_disk_name'] = '/dev/xvdf'
default['jmh_encrypt']['lukscrypt']['volume_name'] = 'crypto'
default['jmh_encrypt']['lukscrypt']['device_prefix'] = '/dev/mapper'
default['jmh_encrypt']['lukscrypt']['volume_size'] = '50GB'
default['jmh_encrypt']['lukscrypt']['luks_device_name'] = 'luksdevice'
default['jmh_encrypt']['lukscrypt']['encrypted_disk_name'] = 'encrypted'
default['jmh_encrypt']['lukscrypt']['encrypted_directory'] = File.join('/', node['jmh_encrypt']['lukscrypt']['encrypted_disk_name'])
# default['jmh_encrypt']['luks_passphrase'] = 'supersecretword'
default['jmh_encrypt']['lukscrypt']['device_path'] = "#{node['jmh_encrypt']['lukscrypt']['device_prefix']}/" \
                     "#{node['jmh_encrypt']['lukscrypt']['volume_name']}-#{node['jmh_encrypt']['lukscrypt']['luks_device_name']}"
