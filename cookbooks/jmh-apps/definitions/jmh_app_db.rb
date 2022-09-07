## DEPRECIATED ##
# 
# # Provides database setup for JMH applications
# define :jmh_app_db, :database => nil, :username => nil, :password => nil, :bind_address => '127.0.0.1', :parent_role => nil, :privileges => [:all], :config => {}, :config_client => {}, :ssl => nil, :connect_over_ssl => nil, :app_alias => nil do
#  
  # # creates secure password if not already set.
  # ::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
  # node.set['mysql']['server_root_password'] = secure_password unless node['mysql']['server_root_password']
# 
# 
  # mysql2_chef_gem 'default' do
    # client_version node['mysql']['version']
    # action :install
  # end
#   
  # # for Test Kitchen purposes
  # # For apps that look for a database on another application, default to just creating the database locally
  # # if Chef::Config[:solo] && params[:parent_role]
  # if node['test_run'] && params[:parent_role]
    # Chef::Log.info("Search does not work with Chef-ZERO")
    # params[:parent_role] = nil
    # app_alias = params[:app_alias]
    # params[:database] = node[:jmh_apps][app_alias][:db][:database]
  # end
#   
#   
  # # Get Database password from databag
  # db_password = nil
  # if (params[:password]) 
    # db_password = params[:password]
  # else
    # app_databag = Chef::EncryptedDataBagItem.load(node[:jmh_apps][:databag][:name],params[:name])
    # db_password = app_databag[node[:jmh_apps][:databag][:password_key]]
  # end
#     
  # # Changed all "role" variables to be "parent_role" for proper database discovery 
  # # If a parent_role parameter is not provided to the definition, then we
  # # know that we need to setup the database on the localhost
  # unless(params[:parent_role])
    # node.set[:mysql][:bind_address] = params[:bind_address]
# 
    # # Create mysql default instance, installs mySQL server  
    # include_recipe 'jmh-db::default'
#     
    # # Create a hash to store our connection informtion
    # mysql_con_info = {
      # :host => '127.0.0.1',
      # :username => 'root', 
      # :password => node['mysql']['server_root_password']
    # }
#   
    # jmh_db_database params[:database] do
      # database params[:database]
      # action :create
    # end
#     
    # # LWRP provided via database cookbook to create DB user
    # mysql_database_user params[:username] do
      # connection mysql_con_info
      # password db_password
      # database_name params[:database]
      # privileges params[:privileges]
      # host node[:ipaddress] if params[:parent_role]
      # require_ssl params[:connect_over_ssl]
      # action :grant
      # not_if do Chef::Config.local_mode & params[:parent_role] end
    # end    
# 
  # else
    # # A parent_role name has been provided in the parameters, so we are
    # # connecting to a remote database.
# 
    # # Searches for a node with the provided parent_role in its runlist as
    # # well as matching the other criteria stated.
    # # This is a helper method provided from the discovery cookbook
    # # Discovery needs to be found via 'raw' method as our nodes roles have multiple 
    # # nodes found if not clearly specified as "roles"
# 
    # p_rl = params[:parent_role]
    # jmh_db_user params[:username] do
      # username params[:username] 
      # password db_password
      # database_name params[:database]
      # parent_node_query "roles:#{p_rl}"
      # privileges params[:privileges]
      # connect_over_ssl true
    # end 
  # end # End unless(parent_role)
# 
#   
  # # Checks to see if the application connection into the database uses SSL
  # if params[:ssl] 
    # include_recipe 'jmh-db::ssl_config'                    
  # end   
# 
  # # LWRP provided via mysql cookbook to create read only DB users
  # # Users should be dropped and re-created every time, otherwise they are no longer active, 
  # #   and should be dropped from the system.
  # db_users = data_bag("db_users")
  # db_users.each do |user_bag|
    # bag = Chef::EncryptedDataBagItem.load('db_users', user_bag).to_hash
    # # Remove inactive users
    # if !bag['active']  
       # mysql_database_user bag['id'] do
          # connection mysql_con_info
          # host node[:ipaddress] if params[:parent_role]
          # action :drop
          # not_if do Chef::Config.local_mode & params[:parent_role] end
       # end
    # # If active, check their access against the current database and grant   
    # elsif bag['active']  
#       
       # db_access = bag['access'].to_hash 
       # if db_access.keys.include?("ALL")
       # # If they have ALL access in their data bag, set that first
       # #TODO If they have ALL access and it is taken away, we need to remove the ALL access Manually
          # mysql_database_user bag['id'] do
              # connection mysql_con_info
              # password bag['password']
              # privileges db_access['ALL']
              # host node[:ipaddress] if params[:parent_role]
              # action :grant
              # not_if do Chef::Config.local_mode & params[:parent_role] end
          # end
       # end
       # # If the current database is in their database access, remove all current access
       # #    and then set the new privileges
       # db_access.keys.each do |dbname|
          # if params[:database] == dbname
              # mysql_database_user 'root' do
                # connection mysql_con_info
                # sql "REVOKE ALL PRIVILEGES ON #{dbname}.* FROM '#{bag['id']}'@'127.0.0.1'"
                # action :query
                # only_if {`mysql -h 127.0.0.1 -u root --password=#{node['mysql']['server_root_password']} -D mysql -r -B -N -e \"select count(*) from user where user = '#{bag['id']}'\"`.to_i == 1 }
                # not_if do Chef::Config.local_mode & params[:parent_role] end
              # end             
#             
              # mysql_database_user bag['id'] do
                  # connection mysql_con_info
                  # database_name dbname
                  # password bag['password']
                  # privileges bag['access'][dbname]
                  # host node[:ipaddress] if params[:parent_role]
                  # action :grant
                  # not_if do Chef::Config.local_mode & params[:parent_role] end
              # end
          # end
       # end
    # end
  # end
#   
  # # [mysqld] parameters to set
  # unless(params[:config].empty?) 
# 
    # mysql_config "#{params[:name]}-server" do
      # source 'mysql.cnf.erb'
      # cookbook 'jmh-apps'
      # instance 'default'
      # variables(
        # :config => params[:config]
      # )
      # notifies :restart, 'mysql_service[default]', :delayed
      # action :create
    # end
#     
  # end 
#   
  # # [client] parameters to set
  # unless(params[:config_client].empty?)
# 
    # mysql_config "#{params[:name]}-client" do
      # source 'mysql_client.cnf.erb'
      # cookbook 'jmh-apps'
      # instance 'default'
      # variables(
        # :config => params[:config_client]
       # )
      # notifies :restart, 'mysql_service[default]', :delayed
      # action :create
    # end 
  # end
#  
# end #end define
