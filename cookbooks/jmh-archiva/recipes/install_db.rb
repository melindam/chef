::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

## Create Databases
node.normal['jmh_archiva']['mysql']['password'] = random_password unless node['jmh_archiva']['mysql']['password'] # NOTE: This method comes from mysql::server

# Install archiva mysql database
jmh_db_database node['jmh_archiva']['mysql']['dbname'] do
  database node['jmh_archiva']['mysql']['dbname']
  bind_address '127.0.0.1'
  action :create
end
jmh_db_user node['jmh_archiva']['mysql']['dbname'] do
  database node['jmh_archiva']['mysql']['dbname']
  username node['jmh_archiva']['mysql']['username']
  password node['jmh_archiva']['mysql']['password']
  parent_node_query 'recipes:jmh-archiva\:\:install_db' unless node['recipes'].include?('jmh-archiva::install_db')
  connect_over_ssl false
  action :create
end

# Install archiva mysql databases, if necessary
if node['jmh_archiva']['rebuild_db']
  # Mysql Standard Call
  my_exe = "#{File.join(node['jmh_archiva']['mysql']['bin_dir'], 'mysql')} --user=root --password=#{node['mysql']['server_root_password']}"

  Chef::Log.info('***Rebuild of the Archiva Database is Called')

  archiva_db_file = File.join(node['jmh_archiva']['scratch_dir'], "#{node['jmh_archiva']['mysql']['dbname']}.sql")

  unless File.exist?(archiva_db_file)
    jmh_utilities_s3_download "#{archiva_db_file}.gz" do
      remote_path "archiva/#{node['jmh_archiva']['mysql']['dbname']}.sql.gz"
      bucket 'jmhapps'
      mode 0644
      action :create
    end
    # gunzip sql file - try to take -f option off when logic built in to only get file and restore if not there.
    execute "unpack #{node['jmh_archiva']['mysql']['dbname']} db" do
      command "gunzip -f #{archiva_db_file}.gz"
      creates archiva_db_file
      action :run
    end

    execute "restore #{node['jmh_archiva']['mysql']['dbname']} db" do
      command "#{my_exe} #{node['jmh_archiva']['mysql']['dbname']} < #{archiva_db_file}"
      action :run
      notifies :restart, 'service[archiva]', :delayed
    end
  end

  node.normal['jmh_archiva']['rebuild_db'] = false
end
