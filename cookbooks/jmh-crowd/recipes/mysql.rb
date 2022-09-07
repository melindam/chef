::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
include_recipe 'jmh-db'

['apache-tomcat/lib', 'apache-tomcat/common/lib'].each do |jar_inst_dir|
  directory File.join(node['jmh_crowd']['install']['current'], jar_inst_dir) do
    action :create
    owner node['jmh_crowd']['run_as']
    group node['jmh_crowd']['run_as']
    recursive true
  end

  mysql_connector_j "Install Mysql Connector in #{jar_inst_dir}" do
    path File.join(node['jmh_crowd']['install']['current'], jar_inst_dir)
    action :create
  end

  execute "change owner mysql-connector*jar for #{jar_inst_dir}" do
    command "chown #{node['jmh_crowd']['run_as']}. mysql-connector*.jar"
    cwd File.join(node['jmh_crowd']['install']['current'], jar_inst_dir)
  end
end

# validate create options character set utf8 collate utf8_bin
jmh_db_database node['jmh_crowd']['mysql']['dbname'] do
  database node['jmh_crowd']['mysql']['dbname']
  action :create
end

if node['jmh_crowd']['mysql']['password'].nil?
  node.normal['jmh_crowd']['mysql']['password'] = random_password
end

jmh_db_user 'crowd_user' do
  database node['jmh_crowd']['mysql']['dbname']
  username node['jmh_crowd']['mysql']['username']
  password node['jmh_crowd']['mysql']['password']
  privileges node['jmh_crowd']['mysql']['privileges']
  connect_over_ssl node['jmh_crowd']['mysql']['connect_over_ssl']
end

mysql_config 'crowd' do
  source 'mysql_crowd.cnf.erb'
  cookbook 'jmh-crowd'
  instance 'default'
  notifies :restart, 'mysql_service[default]', :delayed
  action :create
end
