# database.rb

# use_inline_resources

action :create do
  # Update attributes we want to modify before loading
  node.default_unless['mysql']['bind_address'] = new_resource.bind_address if new_resource.bind_address != '127.0.0.1'

  @run_context.include_recipe 'jmh-db::server'

  # Create a hash to store our connection informtion
  mysql_con_info = {
    :host => '127.0.0.1',
    :username => 'root',
    :password => node['mysql']['server_root_password'],
    :default_file => node['jmh_db']['default_file']
  }

  # LWRP provided by the database cookbook to create a mysql database
  mysql_database new_resource.database do
    connection mysql_con_info
    action :create
  end

  @run_context.include_recipe 'jmh-db::db_backup'

  # LWRP provided via mysql cookbook to create read only DB users
  # Users should be dropped and re-created every time, otherwise they are no longer active,
  #   and should be dropped from the system.
  db_users = data_bag('db_users')
  db_users.each do |user_bag|
    bag = Chef::EncryptedDataBagItem.load('db_users', user_bag).to_hash
    # Remove active and inactive users. Active users will be re-created
    jmh_db_mysql_local_user "drop #{bag['id']} for #{new_resource.database}" do
      username bag['id']
      password bag['password']
      host_connection '127.0.0.1'
      action :drop
    end
    # If active, check their access against the current database and grant
    next unless bag['active']
    db_access = bag['access'].to_hash
    # If they have ALL access in their data bag, set that first
    jmh_db_mysql_local_user "Create #{bag['id']} for #{new_resource.database}" do
      username bag['id']
      password bag['password']
      database '*'
      host_connection '127.0.0.1'
      privileges db_access['ALL'] unless db_access['ALL'].nil?
      action :create
      only_if { db_access.keys.include?('ALL') }
    end
    # If the current database is in their database access, remove all current access
    #    and then set the new privileges
    db_access.keys.each do |dbname|
      next unless new_resource.database == dbname
      jmh_db_mysql_local_user bag['id'] do
        database dbname
        username bag['id']
        password bag['password']
        privileges bag['access'][dbname]
        host_connection '127.0.0.1'
        action :create
      end
    end
  end

  new_resource.updated_by_last_action(true)
end
