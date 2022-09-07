include_recipe 'jmh-operations::default'

package 'rsync' do
  action :install
end

mysql_db_server_list = []
mongodb_db_server_list= []

backup_environments = node['jmh_operations']['archivedb']['prod_backup_environments'] +
                      node['jmh_operations']['archivedb']['dev_backup_environments']

# Get list of mysql DB servers
if Chef::Config[:solo]
  mysql_db_server_list.push('name' => 'test', 'ipaddress' => '127.0.0.1', 'nat_ip' => '127.0.0.1')
else
  search(:node, node['jmh_operations']['archivedb']['mysql_search_query']) do |n|
    if backup_environments.include?(n.environment)
      node_hash = {}
      node_hash['name'] = n.name
      node_hash['ipaddress'] = n['ipaddress']
      node_hash['environment'] = n.environment
      mysql_db_server_list.push(node_hash)
      Chef::Log.info("Adding #{n.name}  #{n['ipaddress']} to db backup list")
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for db backup")
    end
  end
end

Chef::Application.fatal!('No MySQL Servers Found!') if mysql_db_server_list.length == 0

# Get list of MongoDB servers
if Chef::Config[:solo]
  mongodb_db_server_list.push('name' => 'test', 'ipaddress' => '127.0.0.1', 'nat_ip' => '127.0.0.1')
else
  search(:node, node['jmh_operations']['archivedb']['mongodb_search_query']) do |n|
    if backup_environments.include?(n.environment)
      node_hash = {}
      node_hash['name'] = n.name
      node_hash['ipaddress'] = n['ipaddress']
      node_hash['environment'] = n.environment
      mongodb_db_server_list.push(node_hash)
      Chef::Log.info("Adding #{n.name}  #{n['ipaddress']} to MongoDB backup list")
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for MongoDB backup")
    end
  end
end

Chef::Application.fatal!('No MongoDB Servers Found!') if mongodb_db_server_list.length == 0


directory node['jmh_operations']['archivedb']['mysql_backup_dir'] do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

directory node['jmh_operations']['archivedb']['mongodb_backup_dir'] do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

directory File.join(node['jmh_operations']['archivedb']['mysql_backup_dir'], 'weekly') do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

directory File.join(node['jmh_operations']['archivedb']['mongodb_backup_dir'], 'weekly') do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
end

mysql_db_server_list.each do |n|
  directory "#{node['jmh_operations']['archivedb']['mysql_backup_dir']}/#{n['name']}" do
    owner node['jmh_operations']['backup']['user']
    group node['jmh_operations']['backup']['user']
    mode '0700'
  end
  directory File.join(node['jmh_operations']['archivedb']['mysql_backup_dir'], 'weekly', "#{n['name']}") do
    owner node['jmh_operations']['backup']['user']
    group node['jmh_operations']['backup']['user']
    mode '0700'
  end
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_mysql.sh') do
  source 'archive_mysql_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
    :user => node['jmh_operations']['backup']['user'],
    :backup_dir => node['jmh_operations']['archivedb']['mysql_backup_dir'],
    :server_list => mysql_db_server_list,
    :dev_environments => node['jmh_operations']['archivedb']['dev_backup_environments'],
    :jmh_local => node['jmh_server']['jmh_local_server']
  )
end

mongodb_db_server_list.each do |n|
  directory "#{node['jmh_operations']['archivedb']['mongodb_backup_dir']}/#{n['name']}" do
    owner node['jmh_operations']['backup']['user']
    group node['jmh_operations']['backup']['user']
    mode '0700'
  end
  directory File.join(node['jmh_operations']['archivedb']['mongodb_backup_dir'], 'weekly', "#{n['name']}") do
    owner node['jmh_operations']['backup']['user']
    group node['jmh_operations']['backup']['user']
    mode '0700'
  end
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_mongodb.sh') do
  source 'archive_mongodb_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
      :user => node['jmh_operations']['backup']['user'],
      :backup_dir => node['jmh_operations']['archivedb']['mongodb_backup_dir'],
      :mongodb_server_list => mongodb_db_server_list,
      :dev_environments => node['jmh_operations']['archivedb']['dev_backup_environments'],
      :jmh_local => node['jmh_server']['jmh_local_server']
  )
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_weekly_mysql.sh') do
  source 'archive_weekly_mysql_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
    :retention => node['jmh_operations']['archivedb']['weekly']['retention'],
    :backup_dir => node['jmh_operations']['archivedb']['mysql_backup_dir'],
    :server_list => mysql_db_server_list,
    :dailyfile => node['jmh_operations']['archivedb']['weekly']['dailyfile']
  )
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_weekly_mongodb.sh') do
  source 'archive_weekly_mongodb_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
      :retention => node['jmh_operations']['archivedb']['weekly']['retention'],
      :backup_dir => node['jmh_operations']['archivedb']['mongodb_backup_dir'],
      :server_list => mongodb_db_server_list
  )
end

# Slow Query list
server_hash = Hash.new
node['jmh_operations']['slowquery']['database_hash'].each do |db, recipe_query|
  search(:node, recipe_query) do |n|
    if server_hash[n.name]
      server_hash[n.name]['servers'].push(db.to_s)
    else
      server_hash[n.name] = {}
      server_hash[n.name]['servers'] = [db.to_s]
      ipaddress = n['ipaddress']
      if node['test_run'] == true && n['cloud']
        ipaddress = n['cloud']['public_hostname']
      end
      server_hash[n.name]['ipaddress'] = ipaddress
    end
  end
end
Chef::Log.info("this the server_hash: #{server_hash.to_s}")

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'mysql_slow_check.rb') do
  source 'mysql_slow_check_rb.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  action :create
  variables(
    db_list:  node['jmh_operations']['slowquery']['database_hash'].keys,
    server_hash:  server_hash
  )
end


