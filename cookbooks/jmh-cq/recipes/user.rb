# Create the environment for CQ to work in

# Create shared group for use by both cq users
group node['cq']['group'] do
  action :create
end

# Create user that will run CQ
user node['cq']['user'] do
  shell '/bin/false'
  group node['cq']['group']
end

ruby_block "Remove password expire for #{node['cq']['user']}" do
  block do 
     %x(chage -M #{node['jmh_server']['users']['password_expire_days']} #{node['cq']['user']})
  end
end

# create maintance user
user node['cq']['maintenance_user'] do
  shell '/bin/bash'
  group node['cq']['group']
  manage_home true
end

ruby_block "Remove password expire for #{node['cq']['maintenance_user']}" do
  block do 
     %x(chage -M #{node['jmh_server']['users']['password_expire_days']} #{node['cq']['maintenance_user']})
  end
end


directory File.join('home', node['cq']['maintenance_user'], '.ssh') do
  mode 0700
  user node['cq']['maintenance_user']
  group node['cq']['group']
end

rundeck_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'rundeck')
authorized_keys_file_content = rundeck_key_bag['public_key'] + "\n"

file File.join('home', node['cq']['maintenance_user'], '.ssh', 'authorized_keys') do
  content authorized_keys_file_content
  owner node['cq']['maintenance_user']
  group node['cq']['group']
  mode 0600
end

directory node['cq']['base_directory'] do
  # recursive true
  user node['cq']['maintenance_user']
  group node['cq']['group']
  mode 0775
end

directory node['cq']['bin_dir'] do
  user node['cq']['maintenance_user']
  group node['cq']['group']
  mode 0770
end
