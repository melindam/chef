# install mysql DB for pg

::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

if node['jmh_paygateway']['client']['db']['password'].nil?
  node.normal['jmh_paygateway']['client']['db']['password'] = random_password
end
  
jmh_db_database node['jmh_paygateway']['client']['database'] do
  database node['jmh_paygateway']['client']['database']
  action :create
end

jmh_db_user 'paygateway_client_user' do
  database node['jmh_paygateway']['client']['database']
  username node['jmh_paygateway']['client']['db']['username']
  password node['jmh_paygateway']['client']['db']['password']
  parent_node_query node['jmh_paygateway']['client']['db']['node_query'] unless node['recipes'].include?(node['jmh_paygateway']['client']['db']['local_recipe'])
  privileges [:all]
  connect_over_ssl node['jmh_paygateway']['client']['db']['connect_over_ssl']
end

jmh_db_mysql_local_user node['jmh_paygateway']['client']['database'] do
  username node['jmh_paygateway']['client']['db']['developer_user']
  database node['jmh_paygateway']['client']['database']
  password node['jmh_paygateway']['client']['db']['developer_password']
  host_connection '%'
  privileges [:all]
  action %w(dev sbx).include?(node['jmh_server']['environment']) ? :create : :drop
end