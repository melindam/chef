
jmh_db_database node['neprofile']['db']['database'] do
  database node['neprofile']['db']['database']
  action :create
end

# jmh_db_mysql_local_user node['jmh_myjmh']['db']['database'] do
#   username node['jmh_myjmh']['db']['developer_user']
#   database node['jmh_myjmh']['db']['database']
#   password node['jmh_myjmh']['db']['developer_password']
#   host_connection '%'
#   privileges [:all]
#   action %w(dev sbx).include?(node['jmh_server']['environment']) ? :create : :drop
# end
