
catalina_properties = ['# JMH comhub Properties']
catalina_properties.push("# nothing")
catalina_properties.push("# 2 nothing")

node.default['jmh_idev']['appserver']['comhub']['catalina_properties'] = catalina_properties

jmh_tomcat node['jmh_idev']['appserver']['comhub']['name'] do
  enable_http node['jmh_idev']['appserver']['comhub']['enable_http']
  enable_ssl node['jmh_idev']['appserver']['comhub']['enable_ssl']
  java_version node['jmh_idev']['appserver']['comhub']['java_version']
  port node['jmh_idev']['appserver']['comhub']['port']
  shutdown_port node['jmh_idev']['appserver']['comhub']['shutdown_port']
  jmx_port node['jmh_idev']['appserver']['comhub']['jmx_port']
  ajp_port node['jmh_idev']['appserver']['comhub']['ajp_port']
  iptables node['jmh_idev']['appserver']['comhub']['iptables']
  version node['jmh_idev']['appserver']['comhub']['version']
  rollout_array node['jmh_idev']['appserver']['comhub']['rollout_array']
  catalina_properties node['jmh_idev']['appserver']['comhub']['catalina_properties']
  action :create
end

# Mount NFS directory
%w(samba-client samba-common cifs-utils rsync).each do |w_package|
  package w_package do
    action :install
  end
end

node['jmh_idev']['comhub']['rec_directories'].each do |dirname|
  directory dirname do
    mode 0755
    owner 'tomcat'
    group 'tomcat'
    action :create
  end
end

# Mounted to \\hsysnas1.hsys.local\DIAPPS
directory node['jmh_idev']['comhub']['nas_mount_dir'] do
  owner 'tomcat'
  group 'tomcat'
  action :create
end

user_data_bag = Chef::EncryptedDataBagItem.load(node['jmh_idev']['data_bag'], node['jmh_idev']['data_bag_item'])

template '/root/comhub_nas_secret.txt' do
  source 'nas_secret.erb'
  mode 0600
  variables(
      :username => user_data_bag['comhub']['nas_mount_username'],
      :password => user_data_bag['comhub']['nas_mount_password']
  )
  action :create
end

# \\winbox\getme /mnt/win cifs user,uid=500,rw,suid,username=sushi,password=yummy 0 0

# http://www.rubydoc.info/gems/chef/Chef/Util/FileEdit
ruby_block 'update fstab' do
  block do
    f=Chef::Util::FileEdit.new("/etc/fstab")
    f.insert_line_if_no_match(/.*hsysnas1.hsys.local.*/,
                              "\\\\hsysnas1.hsys.local\\DIAPPS #{node['jmh_idev']['comhub']['nas_mount_dir']} cifs uid=tomcat,gid=tomcat,rw,vers=2.1,file_mode=0775,dir_mode=0775,credentials=/root/comhub_nas_secret.txt 0 0")
    f.write_file
  end
end

unless node['cloud']
  execute "Mount #{node['jmh_idev']['comhub']['nas_mount_dir']}" do
    command "mount #{node['jmh_idev']['comhub']['nas_mount_dir']}"
    not_if "df | grep hsysnas1"
  end
else
  Chef::Log.warn("Skipping mount due to cloud system.")
end

# include_recipe 'jmh-idev::mongo_db_comhub'
