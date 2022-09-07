
nodejs_home = "/home/#{node['jmh_nodejs']['user']}"

user node['jmh_nodejs']['user'] do
  action :create
  shell '/bin/bash'
  manage_home true
  home nodejs_home
end

ruby_block "Turn off password reset for #{node['jmh_nodejs']['user']}" do
  block do
    %x(chage -M 99999 #{node['jmh_nodejs']['user']})
  end
end

directory File.join(nodejs_home,'bin') do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
end

directory node['jmh_nodejs']['node_base_path'] do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
end

directory node['jmh_nodejs']['webserver_path'] do
  user node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode 0755
  action :create
end

# Add ssl certs
directory File.join(nodejs_home, 'ssl') do
  owner node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode '0700'
  action :create
end

ssl_databag = Chef::EncryptedDataBagItem.load(node['jmh_nodejs']['ssl']['data_bag'], node['jmh_nodejs']['ssl']['data_bag_item'])
%w(key pem chain).each do |certname|
  file File.join(nodejs_home, 'ssl',certname) do
    content ssl_databag[certname]
    owner node['jmh_nodejs']['user']
    group node['jmh_nodejs']['user']
    mode '0700'
    action :create
  end
end



#  Add the Bamboo authorized key
directory File.join(nodejs_home, '.ssh') do
  owner node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode '0700'
  action :create
end

bamboo_key_bag = Chef::EncryptedDataBagItem.load(node['jmh_nodejs']['bamboo_databag'][0],node['jmh_nodejs']['bamboo_databag'][1])
authorized_keys_file_content = bamboo_key_bag['ssh_public_key']

file File.join(nodejs_home, '.ssh', 'authorized_keys') do
  content authorized_keys_file_content
  owner node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  mode '0600'
end


