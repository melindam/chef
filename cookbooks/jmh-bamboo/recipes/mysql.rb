::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
include_recipe 'jmh-db::default'

if node['jmh_bamboo']['mysql']['password'].nil?
  node.normal['jmh_bamboo']['mysql']['password'] = secure_password
end

# ALTER DATABASE bamboo CHARACTER SET utf8 COLLATE utf8_bin

jmh_db_database 'bamboo' do
  database 'bamboo'
  action :create
end

jmh_db_user 'bamboo' do
  database 'bamboo'
  username 'bamboo'
  password node['jmh_bamboo']['mysql']['password']
  privileges ['all']
  connect_over_ssl false
end

mysql_connector_j File.join(node['jmh_bamboo']['install']['current'], 'atlassian-bamboo/WEB-INF/lib/') do
  action :create
end

include_recipe 'jmh-db::db_backup'
