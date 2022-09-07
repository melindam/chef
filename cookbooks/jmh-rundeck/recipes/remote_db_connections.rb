::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

## Event Manager Report
if node['test_run']
  log 'NOTHING TO DO ON CHEF-ZERO for remote db calls'
else
  node['jmh_rundeck']['remote_db'].each_key do |dbcon|
    Chef::Log.info "dbcon: #{dbcon}"

    if node['jmh_rundeck']['remote_db'][dbcon]['password'].nil?
      node.normal['jmh_rundeck']['remote_db'][dbcon]['password'] = random_password
    end

    jmh_db_user 'events' do
      database node['jmh_rundeck']['remote_db']['events']['database']
      username node['jmh_rundeck']['remote_db']['events']['username']
      password node['jmh_rundeck']['remote_db']['events']['password']
      parent_node_query node['jmh_rundeck']['remote_db']['events']['parent_node_query']
      privileges node['jmh_rundeck']['remote_db']['events']['privileges']
      connect_over_ssl node['jmh_rundeck']['remote_db']['events']['connect_over_ssl']
    end

    directory node['jmh_rundeck']['remote_db_password']['base_dir'] do
      owner node['rundeck']['user']
      group node['rundeck']['user']
      mode '0755'
    end

    file File.join(node['jmh_rundeck']['remote_db_password']['base_dir'], ".#{dbcon}") do
      owner node['rundeck']['user']
      group node['rundeck']['user']
      content node['jmh_rundeck']['remote_db'][dbcon]['password']
      action :create
      mode '600'
    end
  end

end

node.normal['jmh_events']['report']['mysql_password'] = node['jmh_rundeck']['remote_db']['events']['password']
package 'p7zip' do
  action :install
end
include_recipe 'jmh-events::report'
