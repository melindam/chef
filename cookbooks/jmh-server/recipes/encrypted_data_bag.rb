## If you want to change the data bag secret.
## 1) Update node['jmh_server']['secret']['upgrade_secret'] to true
## 2) run chef-client once ON ALL SERVERS and allow it to fail but it will update the secret file
## 3) Upload the secured databags with the new encryption key
## 3a) ./bin/recryptDatabags.rb
## 3b) ./bin/uploadDatabags.sh
## 4) Run chef-client again

remote_file '/etc/chef/encrypted_data_bag_secret' do
  source "https://#{node['jmh_server']['secret']['uri']}"
  owner 'root'
  group 'root'
  mode 0600
  action :create
  only_if { node['jmh_server']['secret']['upgrade_secret'] }
end

file '/etc/chef/encrypted_data_bag_secret' do
  mode 0600
  owner 'root'
  group 'root'
  action :create
  not_if do [ !::File.exists?('/etc/chef') ] end
end

