
# Create user and associated directories
user node['jmh_tomcat']['user'] do
  home '/home/tomcat'
  shell '/bin/bash'
  manage_home true
  # uid 1991
  # gid 1991
  action :create
  not_if 'id tomcat'
end

ruby_block "Remove password expire for tomcat" do
  block do
     %x(chage -M #{node['jmh_server']['users']['password_expire_days']} #{node['jmh_tomcat']['user']})
  end
end

%w(/home/tomcat /home/tomcat/bin /home/tomcat/deploy).each do |tomcatdir|
  directory tomcatdir do
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode '0755'
    action :create
  end
end

#  Add the Bamboo authorized key
directory '/home/tomcat/.ssh' do
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  mode '0700'
  action :create
end

bamboo_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'bamboo')
rundeck_key_bag = Chef::EncryptedDataBagItem.load('credentials', 'rundeck')
authorized_keys_file_content = bamboo_key_bag['ssh_public_key'] + "\n" + rundeck_key_bag['public_key']

file File.join('/home/tomcat', '.ssh', 'authorized_keys') do
  content authorized_keys_file_content
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  mode '0600'
end
