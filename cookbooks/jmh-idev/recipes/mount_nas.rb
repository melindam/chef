# TODO rename this recipe for jmhapp_webserver as there are other systems using NFS mounts

%w(samba-client samba-common cifs-utils rsync).each do |w_package|
  package w_package do
    action :install
  end
end

# Mounted to \\nassvcs01\DIAPPS\ebiz_webserver
directory node['jmh_idev']['jmhweb']['nas_mount_dir'] do
  mode 0777
  action :create
end

# \\winbox\getme /mnt/win cifs user,uid=500,rw,suid,username=sushi,password=yummy 0 0

# http://www.rubydoc.info/gems/chef/Chef/Util/FileEdit
ruby_block 'update fstab' do
  block do
    f=Chef::Util::FileEdit.new("/etc/fstab")
    f.insert_line_if_no_match(/.*nassvcs01.*/,
                              "\\\\nassvcs01.hsys.local\\DIAPPS\\ebiz_webserver #{node['jmh_idev']['jmhweb']['nas_mount_dir']} cifs uid=apache,gid=apache,rw,vers=2.1,file_mode=0777,dir_mode=0777,credentials=/root/nas_secret.txt 0 0")
    f.write_file
  end
end

user_data_bag = Chef::EncryptedDataBagItem.load(node['jmh_idev']['data_bag'], node['jmh_idev']['data_bag_item'])

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
  execute "Mount #{node['jmh_idev']['jmhweb']['nas_mount_dir']}" do
    command "mount #{node['jmh_idev']['jmhweb']['nas_mount_dir']}"
    not_if "df | grep ebiz_webserver"
  end
else
  Chef::Log.warn("Skipping mount due to cloud system.")
end