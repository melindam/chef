::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
# if node['jmh_billpay']['client']['db']['password'].nil?
  # node.normal['jmh_billpay']['client']['db']['password'] = random_password
# end

if node['jmh_billpay']['client']['db']['password'].nil?
  app_databag = Chef::EncryptedDataBagItem.load('jmh_apps','billpay')
  password_key =  case node['jmh_server']['environment']
                  when 'prod'
                    'prod_password'
                  when 'stage'
                    'stage_password'
                  else
                    'dev_password'
                  end
  node.normal['jmh_billpay']['client']['db']['password'] = app_databag[password_key]
end

jmh_db_database node['jmh_billpay']['db']['database'] do
  database node['jmh_billpay']['db']['database']
  action :create
end

jmh_db_user 'billpay_client_user' do
  database node['jmh_billpay']['db']['database']
  username node['jmh_billpay']['client']['db']['username']
  password node['jmh_billpay']['client']['db']['password']
  parent_node_query node['jmh_billpay']['client']['db']['node_query'] unless node['recipes'].include?(node['jmh_billpay']['client']['db']['local_recipe'])
  privileges node['jmh_billpay']['client']['db']['privileges']
  connect_over_ssl node['jmh_billpay']['client']['db']['connect_over_ssl']
end

jmh_db_mysql_local_user node['jmh_billpay']['db']['database'] do
  username node['jmh_billpay']['db']['developer_user']
  database node['jmh_billpay']['db']['database']
  password node['jmh_billpay']['db']['developer_password']
  privileges [:all]
  host_connection '%'
  action %w(dev sbx).include?(node['jmh_server']['environment']) ? :create : :drop
end
