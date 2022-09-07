user node['apache']['user'] do
  shell "/bin/bash"
  uid '1090'
  manage_home true
  action :create
end

directory File.join("/home",node['apache']['user'],'.ssh') do
  action :create
  user node['apache']['user']
  group node['apache']['group']
  mode 0700
end

deploy_key_bag = Chef::EncryptedDataBagItem.load("credentials", "bamboo")

file File.join("/home", node['apache']['user'], '.ssh', 'id_rsa') do
  content deploy_key_bag['ssh_private_key']
  user node['apache']['user']
  group node['apache']['group']
  mode 0600
end

bamboo_key_bag = Chef::EncryptedDataBagItem.load("credentials", "bamboo")
file File.join("/home", node['apache']['user'], '.ssh', 'authorized_keys') do
  content bamboo_key_bag['ssh_public_key']
  user node['apache']['user']
  group node['apache']['group']
  mode 0600
end

known_hosts_files = ''
node['jmh_webserver']['ssh_known_hosts']['bitbucket']['hosts'].each do |hostname|
  known_hosts_files += "#{hostname} " +
                       "#{node['jmh_webserver']['ssh_known_hosts']['bitbucket']['key_type']} " +
                       "#{node['jmh_webserver']['ssh_known_hosts']['bitbucket']['key']}\n"
end
file File.join("/home", node['apache']['user'], '.ssh', 'known_hosts') do
  content known_hosts_files
  user node['apache']['user']
  group node['apache']['group']
  mode 0600
end 