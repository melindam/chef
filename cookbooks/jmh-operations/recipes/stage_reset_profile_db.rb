::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.normal['jmh_operations']['stage_reset']['profile_mysql_password'] = random_password unless node['jmh_operations']['stage_reset']['profile_mysql_password']

sso =  data_bag_item(node['jmh_operations']['stage_reset']['databag'][0],node['jmh_operations']['stage_reset']['databag'][1])

jmh_db_mysql_local_user node['jmh_operations']['stage_reset']['profile_mysql_user'] do
  username node['jmh_operations']['stage_reset']['profile_mysql_user']
  password node['jmh_operations']['stage_reset']['profile_mysql_password']
  database node['jmh_myjmh']['db']['database']
  privileges node['jmh_operations']['stage_reset']['profile_mysql_privileges']
  action :create
end

node.default['jmh_operations']['stage_reset_users']['profile_id'] = sso['stage_reset']['saved_users'].keys.to_s.gsub('"','').gsub('[','').gsub(']','')

template '/home/tomcat/bin/reset_profile_db.sh' do
  source 'reset_profile_db_sh.erb'
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  mode 0700
  variables(
    profile_id_list: node['jmh_operations']['stage_reset_users']['profile_id'],
    mysql_user: node['jmh_operations']['stage_reset']['profile_mysql_user'],
    host: node['jmh_operations']['stage_reset']['profile_mysql_host'],
    password: node['jmh_operations']['stage_reset']['profile_mysql_password'],
    database: node['jmh_myjmh']['db']['database']
  )
end