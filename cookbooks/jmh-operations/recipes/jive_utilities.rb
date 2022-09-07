# DEPRECATED
include_recipe 'jmh-nodejs::default'

# NAS for jive_utilities Service Desk data location
# \\hsysnas1.hsys.local\DEPT\jive_utilities /usr/local/webapps/jive_utilities cifs uid=jmhbackup,gid=jmhbackup,rw,vers=2.1,file_mode=0777,dir_mode=0777,credentials=/root/nas_secret.txt 0 0

# NFS Mount systems needed packages
%w(samba-client samba-common cifs-utils rsync).each do |w_package|
  package w_package do
    action :install
  end
end

directory '/usr/local/webapps' do
  mode 0755
  action :create
end

# Mounted to \\hsysnas1.hsys.local\DEPT\jive_utilities\
directory node['jmh_operations']['jive_utilities']['nas_mount_dir'] do
  mode 0755
  action :create
end

# \\winbox\getme /mnt/win cifs user,uid=500,rw,suid,username=sushi,password=yummy 0 0

# http://www.rubydoc.info/gems/chef/Chef/Util/FileEdit
ruby_block 'update fstab' do
  block do
    f=Chef::Util::FileEdit.new("/etc/fstab")
    f.insert_line_if_no_match(/.*hsysnas1.*/,
                              "\\\\hsysnas1.hsys.local\\DEPT\\ITS #{node['jmh_operations']['jive_utilities']['nas_mount_dir']} cifs uid=jmhbackup,gid=jmhbackup,rw,vers=2.1,file_mode=0755,dir_mode=0755,credentials=/root/jive_utilities_nas_secret.txt 0 0")
    f.write_file
  end
end

jive_utilities_bag = Chef::EncryptedDataBagItem.load(node['jmh_operations']['jive_utilities']['data_bag'], node['jmh_operations']['jive_utilities']['data_bag_item'])

template '/root/jive_utilities_nas_secret.txt' do
  source 'nas_secret.erb'
  mode 0600
  variables(
      :username => jive_utilities_bag['id'],
      :password => jive_utilities_bag['password']
  )
  action :create
end

unless node['cloud']
  execute "Mount #{node['jmh_operations']['jive_utilities']['nas_mount_dir']}" do
    command "mount #{node['jmh_operations']['jive_utilities']['nas_mount_dir']}"
    not_if "df | grep hsysnas1"
  end
else
  Chef::Log.warn("Skipping mount due to cloud system.")
end

# create directory under nodeapp
directory node['jmh_operations']['jive_utilities']['install_dir'] do
  owner node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  action :create
end

template '/home/nodejs/bin/deploy_jive_utilities.sh' do
  source 'deploy_jive_utilities.erb'
  mode 0755
  owner node['jmh_nodejs']['user']
  group node['jmh_nodejs']['user']
  action :create
end