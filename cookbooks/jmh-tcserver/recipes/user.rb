node.set['jmh_tcserver']['user_home'] = "/home/#{node['jmh_tcserver']['user']}"

user node['jmh_tcserver']['user'] do 
  action :create 
  shell '/bin/bash'
end

directory File.join(node['jmh_tcserver']['user_home'], 'bin') do
  action :create
  owner node['jmh_tcserver']['user']
  group node['jmh_tcserver']['group']
end


template File.join(node['jmh_tcserver']['user_home'],'bin','runTCServerRollout.sh') do
  source 'rollout.erb'
  mode 0755
  owner node['jmh_tcserver']['user']
  group node['jmh_tcserver']['group']
end

directory File.join(node['jmh_tcserver']['user_home'], 'deploy') do
  action :create
  owner node['jmh_tcserver']['user']
  group node['jmh_tcserver']['group']
end


directory File.join(node['jmh_tcserver']['user_home'], '.ssh') do
  action :create
  owner node['jmh_tcserver']['user']
  group node['jmh_tcserver']['group']
end

deploy_key_bag = Chef::EncryptedDataBagItem.load("deploy_keys", "github")

file File.join(node['jmh_tcserver']['user_home'], '.ssh', 'id_rsa') do
  content deploy_key_bag['deploy_key']
  owner node['jmh_tcserver']['user']
  group node['jmh_tcserver']['group']
  mode 0600
end

ssh_known_hosts_entry 'github.com'

bamboo_key_bag = Chef::DataBagItem.load("bamboo","bamboo")
file File.join(node['jmh_tcserver']['user_home'], '.ssh', 'authorized_keys') do
  content bamboo_key_bag['id_rsa_pub']
  owner node['jmh_tcserver']['user']
  group node['jmh_tcserver']['group']
  mode 0600
end
