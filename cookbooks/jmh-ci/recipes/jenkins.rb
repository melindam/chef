jmh_java_install "install java for #{node['jmh-ci']['jenkins']['java_version']}" do
  version node['jmh-ci']['jenkins']['java_version']
  action :install
end

include_recipe 'jmh-utilities::hostsfile_hsysdc'
# TODO need to add all awstst2 awsdev2 environment hosts entries for testing all front end.
# Manually entered them for now on jenkins server
include_recipe 'jmh-utilities::hostsfile_www_servers'

link '/usr/bin/java' do
  to "#{JmhJavaUtil.get_java_home(node['jmh-ci']['jenkins']['java_version'],node)}/bin/java"
  link_type :symbolic
end

include_recipe 'iptables'
iptables_list = { 'portlist' => {node['jenkins']['master']['port'] => { 'target' => 'ACCEPT' } } }
iptables_rule "jenkins" do
  source 'jenkins_iptables.erb'
  variables iptables_list
  enable true
end

# Setup User Directory
user node['jenkins']['master']['user'] do
  comment 'User for running jenkins'
  manage_home true
  home '/home/jenkins'
  shell '/bin/bash'
end

directory '/home/jenkins/.ssh' do
  user node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0700
  action :create
end

bamboo_databag = Chef::EncryptedDataBagItem.load(node['jmh-ci']['jenkins']['credentials_data_bag'][0],
                                                 node['jmh-ci']['jenkins']['credentials_data_bag'][1])

file '/home/jenkins/.ssh/id_rsa' do
  content bamboo_databag['ssh_private_key']
  user node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0700
  action :create
end

nodejs_version = node['jmh_nodejs']['default_version']
nodejs_path = JmhNodejsUtil.get_nodejs_home(nodejs_version,node)

template '/home/jenkins/.bash_profile' do
  source 'jenkins_bash_profile.erb'
  user node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0600
  variables(
    :node_path =>  nodejs_path,
    :chrome_path => node['jmh-ci']['chrome_path']
  )
  action :create
end

directory '/home/jenkins/.aws' do
  user node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  action :create
end
aws_databag = Chef::EncryptedDataBagItem.load(node['jmh-ci']['jenkins']['aws_data_bag'][0],
                                              node['jmh-ci']['jenkins']['aws_data_bag'][1])

cloudcli_aws_credentials '/home/jenkins/.aws/credentials' do
  owner 'jenkins'
  group node['jenkins']['master']['group']
  mode 0600
  credential_params(
      aws_access_key_id: aws_databag['iam']['chef']['access_key'],
      aws_secret_access_key: aws_databag['iam']['chef']['secret_key']
  )
end

directory '/home/jenkins/jenkinsbackup' do
  user node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0750
  action :create
end


file "/home/jenkins/.secret" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0600
  content ::File.open(node['jmh-ci']['jenkins']['secret_file']).read
  action :create
end


directory '/home/jenkins/.chef' do
  user node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  action :create
end

ebusiness_databag = Chef::EncryptedDataBagItem.load(node['jmh-ci']['jenkins']['ebusiness_data_bag'][0],
                                                    node['jmh-ci']['jenkins']['ebusiness_data_bag'][1])

file File.join('/home/jenkins/.chef', "#{ebusiness_databag['chef_username']}.pem") do
  content ebusiness_databag['chef_private_key']
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0600
  action :create
end

include_recipe "jenkins::master"

%w(git gcc).each do |pack|
  package pack
end

node['jmh-ci']['jenkins']['plugins'].each do |plugin|
  jenkins_plugin plugin do
    action :install
    notifies :restart, 'service[jenkins]', :delayed
  end
end

include_recipe 'chefdk' unless "rpm -q chefdk-#{node['chefdk']['version']}"
link '/usr/bin/chef-client' do
  to '/opt/chef/embedded/bin/chef-client'
  action :create
end

# Install node for npm tests
include_recipe 'jmh-nodejs::default'

yum_repository 'google-chrome' do
  description "google-chrome - $basearch"
  baseurl "http://dl.google.com/linux/chrome/rpm/stable/x86_64"
  gpgcheck true
  gpgkey "https://dl-ssl.google.com/linux/linux_signing_key.pub"
  action :create
end

%w(bc cups-client liberation-fonts-common liberation-fonts google-chrome-stable).each do |pkgname|
  yum_package pkgname do
    package_name pkgname
    options "-y --skip-broken"
    action :install
  end
end

service 'jenkins' do
  action [:enable, :start]
end