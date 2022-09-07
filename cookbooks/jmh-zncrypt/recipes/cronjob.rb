# Add backup script 

directory "/root/bin" do
  owner "root"
  group "root" 
  mode 0755
  action :create
end

template "/root/bin/zncryptBackup.sh" do
  source "zncryptBackup.erb"
  owner "root"
  group "root" 
  mode 0755
  action :create
end


# Add cron entry for backup script
cron "zncrypt_backup" do
  action :create
  minute "30"
  hour "6"
  weekday "*"
  user "root"
  command "/root/bin/zncryptBackup.sh"
end

# modify root email to cron job zncrypt.ping

