# This recipe is no longer used Dec 2018
# https://wiki.centos.org/TipsAndTricks/WindowsShares
%w(samba-client samba-common cifs-utils rsync).each do |w_package|
  package w_package do
    action :install
  end
end

# Mounted to \\nassvcs01\OnBase_eBiz
directory node['jmh_prereg']['nas_mount_dir'] do
  action :create
end

# \\winbox\getme /mnt/win cifs user,uid=500,rw,suid,username=sushi,password=yummy 0 0

# http://www.rubydoc.info/gems/chef/Chef/Util/FileEdit
ruby_block 'update fstab' do
  block do
    f=Chef::Util::FileEdit.new("/etc/fstab")
    f.insert_line_if_no_match(/.*nassvcs01.*/,
                               "\\\\nassvcs01.hsys.local\\OnBase_eBiz #{node['jmh_prereg']['nas_mount_dir']} cifs uid=jmhbackup,gid=jmhbackup,user,rw,vers=2.1,credentials=/root/nas_secret.txt 0 0")
    f.write_file
  end
end

user_data_bag = Chef::EncryptedDataBagItem.load(node['jmh_prereg']['data_bag'], node['jmh_prereg']['data_bag_item'])

template '/root/nas_secret.txt' do
  source 'nas_secret.erb'
  mode 0600
  variables(
    :username => user_data_bag['nas_mount_username'],
    :password => user_data_bag['nas_mount_password']
    )
  action :create
end

unless node['cloud']
  execute "Mount #{node['jmh_prereg']['nas_mount_dir']}" do
    command "mount #{node['jmh_prereg']['nas_mount_dir']}"
    not_if "df | grep nas_prereg_onbase"
  end
else
  Chef::Log.warn("Skipping mount due to cloud system.")
end


# Rundeck script creation for job
prereg_prod_host = '127.0.0.1'

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.') if Chef::Config[:solo]
  prereg_prod_host = '127.0.0.1'
else
  search(:node, "#{node['jmh_prereg']['client_recipe']}") do |n|
    next unless n.environment == node['jmh_prereg']['prod_env']
    prereg_prod_host = n['ipaddress']
    break
  end
end

template '/home/jmhbackup/bin/prereg_copy.sh' do
  source 'prereg_copy.erb'
  action :create
  owner 'jmhbackup'
  group 'jmhbackup'
  mode '0700'  
  variables(
    :host => "#{prereg_prod_host}",
    :user => 'jmhbackup'
  )
end