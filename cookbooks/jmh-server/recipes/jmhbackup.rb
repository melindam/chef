# create backup user

group node['jmh_server']['backup']['group'] do
  gid 1990
  action :create
end

user node['jmh_server']['backup']['username'] do
  action :create
  uid 1990
  shell '/bin/bash'
  gid 1990
  manage_home true
  home node['jmh_server']['backup']['home']
end

ruby_block "Turn off password reset for jmhbackup" do
  block do
    %x(chage -M #{node['jmh_server']['users']['password_expire_days']} jmhbackup)
  end
end

directory File.join(node['jmh_server']['backup']['home'],".ssh") do
  user node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode 0700
end

jmhbackup_public_keys = Array.new

node['jmh_server']['backup']['authorized_keys'].each do |dbag|
 if dbag['encrypted']
   eBag = Chef::EncryptedDataBagItem.load(dbag['databag'], dbag['databag_item'])
   jmhbackup_public_keys.push(eBag[dbag['record']])
 else
    ueBag = Chef::DataBagItem.load(dbag['databag'], dbag['databag_item'])
    jmhbackup_public_keys.push(ueBag[dbag['record']])
 end
end

file File.join(node['jmh_server']['backup']['home'],".ssh","authorized_keys") do
  user node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode "0600"
  content jmhbackup_public_keys.join("\n")
end

directory File.join(node['jmh_server']['backup']['home'],"bin") do
  user node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode 0755
end
