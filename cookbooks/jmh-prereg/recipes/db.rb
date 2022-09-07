if node['jmh_prereg']['client']['db']['password'].nil?
  app_databag = Chef::EncryptedDataBagItem.load('jmh_apps','preregistration')
  password_key =  case node['jmh_server']['environment']
                  when 'prod'
                    'prod_password'
                  when 'stage'
                    'stage_password'
                  else
                    'dev_password'
                  end
  node.normal['jmh_prereg']['client']['db']['password'] = app_databag[password_key]
end

jmh_db_database node['jmh_prereg']['client']['database'] do
  database node['jmh_prereg']['client']['database']
  action :create
end

jmh_db_user 'prereg_client_user' do
  database node['jmh_prereg']['client']['database']
  username node['jmh_prereg']['client']['db']['username']
  password node['jmh_prereg']['client']['db']['password']
  parent_node_query node['jmh_prereg']['client']['db']['node_query'] unless node['recipes'].include?(node['jmh_prereg']['client']['db']['local_recipe'])
  privileges node['jmh_prereg']['client']['db']['privileges']
  connect_over_ssl node['jmh_prereg']['client']['db']['connect_over_ssl']
end

jmh_db_mysql_local_user node['jmh_prereg']['client']['database'] do
  username node['jmh_prereg']['db']['developer_user']
  database node['jmh_prereg']['client']['database']
  password node['jmh_prereg']['db']['developer_password']
  host_connection '%'
  privileges [:all]
  action %w(dev sbx).include?(node['jmh_server']['environment']) ? :create : :drop
end