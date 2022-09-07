
jmh_java_install 'install java' do
  version node['can_mycanopy']['pingfederate']['java_version']
  action :install
end

include_recipe 'pingfederate::standalone'

include_recipe 'can-mycanopy::hostsfile_canopyhealth_servers'

cookbook_file File.join(node['pingfed']['symbolic_install_path'], '/server/default/conf', 'pingfederate.lic') do
  source "pingfederate/#{node['can_mycanopy']['pingfederate']['license_file']}"
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode 0600
  action :create
  notifies :restart, 'service[pingfederate]', :delayed
end

iptables_rule 'pingfederate' do
  cookbook 'can-mycanopy'
  source 'iptables.erb'
  variables node['can_mycanopy']['pingfederate']['iptables']
  enable node['can_mycanopy']['pingfederate']['iptables']['portlist'].length != 0 ? true : false
end

# For deployment of canopy-client CSS files
%w(/home/pingfederate/deploy /home/pingfederate/deploy.prev /home/pingfederate/bin).each do |pingfeddir|
  directory pingfeddir do
    owner node['pingfed']['user']
    group node['pingfed']['user']
    mode '0755'
    action :create
  end
end

#  Add the Bamboo authorized key
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

template '/home/pingfederate/bin/deploy_pingfed.sh' do
  source 'deploy_pingfed_sh.erb'
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode '0755'
end