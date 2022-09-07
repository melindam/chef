# user.rb

# use_inline_resources

# require "mixlib-shellout"
action :create do
  @run_context.include_recipe 'jmh-db::client'
    
  # A parent_role name has been provided in the parameters, so we are
  # connecting to a remote database.

  # Searches for a node with the provided parent_role in its runlist as
  # well as matching the other criteria stated.
  # This is a helper method provided from the discovery cookbook
  # Discovery needs to be found via 'raw' method as our nodes roles have multiple
  # nodes found if not clearly specified as "roles"
  local_ip = 'localhost'
  db_server = {}
  if Chef::Config[:solo] || !new_resource.parent_node_query
    Chef::Log.warn('This recipe uses search. Chef Solo does not support search.') if Chef::Config[:solo]
    db_server['name'] = '127.0.0.1'
    db_server['ipaddress'] = '127.0.0.1'
    db_server['root_password'] = node['mysql']['server_root_password']
  elsif new_resource.parent_node_query
    search(:node, new_resource.parent_node_query) do |n|
      Chef::Log.debug("***This node is #{n.name}")
      next unless n.environment == node.environment
      if n['ipaddress'] == node['ipaddress']
        db_server['name'] = '127.0.0.1'
        db_server['ipaddress'] = '127.0.0.1'
        db_server['root_password'] = node['mysql']['server_root_password']
        local_ip = '127.0.0.1'
        break
      else
        # IF AWS Server, need to use cloud ip address
        db_server['name'] = node['cloud'] ? node['cloud']['local_hostname'] : node['ipaddress']
        db_server['ipaddress'] = n['cloud'] ? n['cloud']['local_ipv4'] : n['ipaddress']
        db_server['root_password'] = n['mysql']['server_root_password']
        local_ip = node['cloud'] ? node['cloud']['local_ipv4'] : node['ipaddress']
      end
    end
  end

  Chef::Application.fatal!("No parent node found for search #{new_resource.parent_node_query}") if db_server['name'].nil?

  # Create a hash to store our connection informtion
  mysql_con_info = {
    :host =>  db_server['ipaddress'],
    :username => 'root',
    :password => db_server['root_password'],
    :default_file => node['jmh_db']['default_file']
  }

  # LWRP provided via database cookbook to create DB user
  mysql_database_user new_resource.username do
    connection mysql_con_info
    password new_resource.password
    database_name new_resource.database
    privileges new_resource.privileges
    default_file node['jmh_db']['default_file']
    host local_ip
    require_ssl new_resource.connect_over_ssl
    action :grant
  end

  new_resource.updated_by_last_action(true)
end
