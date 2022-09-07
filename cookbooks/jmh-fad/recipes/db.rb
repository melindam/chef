

node.default['mysql']['bind_address'] = '0.0.0.0'

jmh_db_database node['jmh_fad']['client']['database'] do
  database node['jmh_fad']['client']['database']
  action :create
end

jmh_db_mysql_local_user node['jmh_fad']['client']['database'] do
  username node['jmh_fad']['db']['developer_user']
  database node['jmh_fad']['client']['database']
  password node['jmh_fad']['db']['developer_password']
  host_connection '%'
  privileges [:all]
  action %w(dev sbx).include?(node['jmh_server']['environment']) ? :create : :drop
end
