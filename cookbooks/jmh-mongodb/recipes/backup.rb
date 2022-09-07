include_recipe 'jmh-server::jmhbackup'

# put template into place
directory '/root/bin for mongodb_backup' do
  path '/root/bin'
  owner 'root'
  group 'root'
  mode 0700
  action :create
end


# IF lukscrypt is present, it means there is an encrypted folder to use instead
if node['recipes'].include?('jmh-encrypt::lukscrypt')
  if ::File.exist?(File.join(node['jmh_server']['backup']['home'], node['jmh_mongodb']['backup']['base_dir']))
    backup_dir = ::File.new(::File.join(node['jmh_server']['backup']['home'], node['jmh_mongodb']['backup']['base_dir']))
    unless ::File.symlink?(backup_dir)
      FileUtils.mv File.join(node['jmh_server']['backup']['home'], node['jmh_mongodb']['backup']['base_dir']),
                   File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], node['jmh_mongodb']['backup']['base_dir'])
    end
  end

  directory File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'],  node['jmh_mongodb']['backup']['base_dir']) do
    owner node['jmh_server']['backup']['username']
    group node['jmh_server']['backup']['group']
    mode '2740'
    action :create
  end

  link File.join(node['jmh_server']['backup']['home'], node['jmh_mongodb']['backup']['base_dir']) do
    to File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], node['jmh_mongodb']['backup']['base_dir'])
    action :create
  end

else
  directory File.join(node['jmh_server']['backup']['home'], node['jmh_mongodb']['backup']['base_dir']) do
    owner node['jmh_server']['backup']['username']
    group node['jmh_server']['backup']['group']
    mode 00755
    action :create
  end
end


directory File.join(node['jmh_server']['backup']['home'],"mongodb") do
  owner node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode 0755
  action :create
end

template '/root/bin/backup_mongodb.sh' do
  source 'backup_mongodb.sh.erb'
  mode 0700
  owner 'root'
  group 'root'
  variables(
      backup_dir: File.join(node['jmh_server']['backup']['home'],node['jmh_mongodb']['backup']['base_dir']),
      db_password: node['mongodb']['authentication']['password']
  )
end

cron 'backup_mongodb' do
  minute node['jmh_mongodb']['backup']['minute_interval']
  hour node['jmh_mongodb']['backup']['hour_interval']
  day node['jmh_mongodb']['backup']['day_interval']
  weekday node['jmh_mongodb']['backup']['weekday_interval']
  command '/root/bin/backup_mongodb.sh > /root/backup_mongodb.log 2>&1'
  user 'root'
  action :create
end
