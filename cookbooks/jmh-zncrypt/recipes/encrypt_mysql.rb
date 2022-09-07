# Encrypts the DB included in the array defined in the role
mount_point = node[:zncrypt][:mount_point]

db = node[:zncrypt][:db_names]

if encrypt_db_bootstrap.nil? 

  db.each do |dbs|
    bash "encrypt db" do
      user = "root"
      code <<-EOH
      "printf #{passphrase}\n" | /usr/sbin/zncrypt-move mysql-encrypt #{mount_point} #{dbs}
      EOH
    end
  end  

node.set[:zncrypt][:encrypt_db_bootstrap] = true
end
