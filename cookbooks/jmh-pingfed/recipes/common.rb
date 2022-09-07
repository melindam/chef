
# For deployment of CSS files
%w(/home/pingfederate/deploy /home/pingfederate/deploy.prev /home/pingfederate/bin /home/pingfederate/src).each do |pingfeddir|
  directory pingfeddir do
    owner node['pingfed']['user']
    group node['pingfed']['user']
    mode '0755'
    action :create
  end
end

package "rsync"

# Add pingfed group to jmhbackup user for access to backups
execute 'Add pingfed to jmhbackup group' do
  command "/usr/sbin/usermod -G #{node['jmh_server']['backup']['group']} #{node['pingfed']['user']} "
  only_if { `id #{node['pingfed']['user']} | grep #{node['jmh_server']['backup']['group']} > dev/null 2>&1` != '0' }
end

# Add the Bamboo authorized key
directory '/home/pingfederate/.ssh' do
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode '0500'
  action :create
end

bamboo_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'bamboo')
authorized_keys_file_content = bamboo_key_bag['ssh_public_key']

file File.join('/home/pingfederate', '.ssh', 'authorized_keys') do
  content authorized_keys_file_content
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode '0600'
end
