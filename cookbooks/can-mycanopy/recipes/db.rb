# Created MySQL database for canopyhealth.com site

# Find a Doctor database and user
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
if node['can_mycanopy']['fad']['db']['password'].nil?
  node.set['can_mycanopy']['fad']['db']['password'] = secure_password
end

jmh_db_database node['can_mycanopy']['fad']['db']['database'] do
  database node['can_mycanopy']['fad']['db']['database']
  action :create
end

jmh_db_user node['can_mycanopy']['fad']['db']['user'] do
  database node['can_mycanopy']['fad']['db']['database']
  username node['can_mycanopy']['fad']['db']['user']
  password node['can_mycanopy']['fad']['db']['password']
  privileges node['can_mycanopy']['fad']['db']['privileges']
  connect_over_ssl node['can_mycanopy']['fad']['db']['connect_over_ssl']
end

jmh_db_mysql_local_user node['can_mycanopy']['fad']['db']['database'] do
  username node['can_mycanopy']['fad']['db']['developer_user']
  database node['can_mycanopy']['fad']['db']['database']
  password node['can_mycanopy']['fad']['db']['developer_password']
  host_connection '%'
  action %w(dev sbx).include?(node['jmh_server']['environment']) ? :create : :drop
end
