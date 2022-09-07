
user node['jmh_bamboo']['run_as'] do
  action :create
  shell '/bin/bash'
  manage_home true
end

# Setup SSH Keys
directory File.join('home', node['jmh_bamboo']['run_as'], '.ssh') do
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0700
end

bamboo_secure = Chef::EncryptedDataBagItem.load('credentials', 'bamboo')
file File.join('home', node['jmh_bamboo']['run_as'], '.ssh', 'id_rsa') do
  content bamboo_secure['ssh_private_key']
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0700
end
