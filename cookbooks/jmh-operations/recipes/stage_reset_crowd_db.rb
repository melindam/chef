::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.normal['jmh_operations']['stage_reset']['crowd_mysql_password'] =  random_password unless node['jmh_operations']['stage_reset']['crowd_mysql_password']

sso =  data_bag_item(node['jmh_operations']['stage_reset']['databag'][0],node['jmh_operations']['stage_reset']['databag'][1])

jmh_db_mysql_local_user node['jmh_operations']['stage_reset']['crowd_mysql_user'] do
  username node['jmh_operations']['stage_reset']['crowd_mysql_user']
  password node['jmh_operations']['stage_reset']['crowd_mysql_password']
  database node['jmh_crowd']['mysql']['dbname']
  privileges node['jmh_operations']['stage_reset']['crowd_mysql_privileges']
  action :create
end

crowd_username_array = Array.new
sso['stage_reset']['saved_users'].each_key do |saved_user|
  crowd_username_array.push(sso['stage_reset']['saved_users'][saved_user]['crowd_username'])
end

node.default['jmh_operations']['stage_reset_users']['crowd_username'] = crowd_username_array

template '/home/tomcat/bin/reset_crowd_db.sh' do
  source 'reset_crowd_db_sh.erb'
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  mode 0700
  variables(
      user_array: node['jmh_operations']['stage_reset_users']['crowd_username'],
      mysql_user: node['jmh_operations']['stage_reset']['crowd_mysql_user'],
      host: node['jmh_operations']['stage_reset']['crowd_mysql_host'],
      password: node['jmh_operations']['stage_reset']['crowd_mysql_password'],
      database: node['jmh_crowd']['mysql']['dbname'],
      crowd_directory_id: sso['stage_reset']['crowd_directory_id'],
      crowd_applications: sso['stage_reset']['crowd_applications'],
      profilenonuser_password: sso['stage_reset']['profilenonuser_password'],
      default_password: sso['stage_reset']['default_password']
  )
end