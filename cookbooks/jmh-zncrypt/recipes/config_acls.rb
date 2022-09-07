
# pull the directory configuration from the data bags
zmount= node[:zncrypt][:mount_point]
zstorage = node[:zncrypt][:storage]
passphrase = node[:zncrypt][:passphrase]
#passphrase2 = node[:zncrypt][:passphrase2]

if passphrase.nil?
 # check if there is a masterkey_bag otherwise skip activation
 data_bag('masterkey_bag')
 # we also need a passhprase and second passphrase, we will generate a random one
 # JMH is not going to use a 2nd passphrase or a databag yet
 passphrase=data_bag_item('masterkey_bag', 'key1')['passphrase']
 passphrase2=data_bag_item('masterkey_bag', 'key1')['passphrase2']
end
 
%w(/zncrypt/storage /zncrypt/zncrypted).each do |dir|
   directory dir do
        recursive true
        owner 'root'
        group 'root'
     end
end

execute "zncrypt-prepare" do
  command "printf '#{passphrase}\n' | zncrypt-prepare #{zstorage} #{zmount}"
  action :run
  not_if { ::File.exists?("/etc/zncrypt/ztrustee/deposits/zncrypt.storage") }
end 
 

# moves directory to encrypted area and creates all ACLs 
if File.exists?("/home/jmhbackup/mysqlbackup") 
  if !File.exists?("/zncrypt/zncrypted/mysqlBackups")
    bash "zncrypt_move_mysqlbackups" do 
      code <<-EOH
       printf '#{passphrase}\n#{passphrase}\n' | /usr/sbin/zncrypt-move encrypt @mysqlBackups /home/jmhbackup/mysqlbackup #{zmount}
       printf '#{passphrase}\n#{passphrase}\n' | /usr/sbin/zncrypt acl --add --rule="ALLOW @mysqlBackups home/jmhbackup/mysqlbackup/* /root/bin/backup_mysql.sh --shell=/bin/bash --children=/bin/gzip,/usr/bin/find"
       printf '#{passphrase}\n#{passphrase}\n' | /usr/sbin/zncrypt acl --add --rule="ALLOW @mysqlBackups home/jmhbackup/mysqlbackup/* /usr/bin/rsync"
     EOH
     end
   end  
 end