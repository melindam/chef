::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)


Chef::Application.fatal!("Lukscrypt only works for Centos or RHEL") unless node['platform_family'] == 'rhel'

template '/etc/security/pwquality.conf' do
  source 'pwquality_conf.erb'
  action :create
end


node.normal['jmh_encrypt']['luks_passphrase'] = random_password + random_password + random_password unless node['jmh_encrypt']['luks_passphrase']

include_recipe 'dm-crypt::default'

package 'lvm2' do
  action :install
end

# Create the Volume Group, if it does not exist
ruby_block "Create Volume Group #{node['jmh_encrypt']['lukscrypt']['volume_name']}" do
  block do
    JmhEncrypt::Helper.create_volume_group(node['jmh_encrypt']['lukscrypt']['volume_name'], node['jmh_encrypt']['lukscrypt']['physical_disk_name'])
  end
  action :run
  not_if { JmhEncrypt::Helper.volume_group_available?(node['jmh_encrypt']['lukscrypt']['volume_name']) }
end

# Create Logical Volume
ruby_block "Create LV #{node['jmh_encrypt']['lukscrypt']['luks_device_name']}" do
  block do
    JmhEncrypt::Helper.create_volume(node['jmh_encrypt']['lukscrypt']['volume_size'],
                                     node['jmh_encrypt']['lukscrypt']['luks_device_name'],
                                     node['jmh_encrypt']['lukscrypt']['volume_name'])
  end
  action :run
  not_if { JmhEncrypt::Helper.disk_available?(node['jmh_encrypt']['lukscrypt']['luks_device_name']) }
end

# Create LUKS Disk
dmcrypt_device 'encrypted' do
  device node['jmh_encrypt']['lukscrypt']['device_path']
  passphrase node['jmh_encrypt']['luks_passphrase']
end

# Create new encrypted disk
ruby_block "Create Disk #{node['jmh_encrypt']['lukscrypt']['encrypted_disk_name']}" do
  block do
    JmhEncrypt::Helper.create_luks_device(node['jmh_encrypt']['luks_passphrase'],
                                          node['jmh_encrypt']['lukscrypt']['device_path'],
                                          node['jmh_encrypt']['lukscrypt']['encrypted_disk_name'])
  end
  action :run
  not_if do
    JmhEncrypt::Helper.disk_available?(File.join(node['jmh_encrypt']['lukscrypt']['device_prefix'],
                                                 node['jmh_encrypt']['lukscrypt']['encrypted_disk_name']))
  end
end

# Format ext4 to new encrypted drive
ruby_block "Format Disk #{node['jmh_encrypt']['lukscrypt']['encrypted_disk_name']}" do
  block do
    JmhEncrypt::Helper.format_ext4(File.join(node['jmh_encrypt']['lukscrypt']['device_prefix'], node['jmh_encrypt']['lukscrypt']['encrypted_disk_name']))
  end
  action :run
  not_if { system("file --dereference --special-files #{node['jmh_encrypt']['lukscrypt']['device_prefix']}/#{node['jmh_encrypt']['lukscrypt']['encrypted_disk_name']} | grep ext4") }
end

directory node['jmh_encrypt']['lukscrypt']['encrypted_directory'] do
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

# Mount encrypted volume
mount node['jmh_encrypt']['lukscrypt']['encrypted_directory'] do
  device "#{node['jmh_encrypt']['lukscrypt']['device_prefix']}/#{node['jmh_encrypt']['lukscrypt']['encrypted_disk_name']}"
  action :mount
end
