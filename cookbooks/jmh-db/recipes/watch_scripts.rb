

package "mutt"

directory File.dirname(node['jmh_db']['watch_script']['name']) do
  action :create
end

template node['jmh_db']['watch_script']['ruby_script'] do
  source 'check_mysql_processlist_rb.erb'
  mode 0700
  action :create
  variables(
      username: node['jmh_db']['monitor']['user'],
      password: node['jmh_db']['monitor']['password'],
      host: '127.0.0.1'
  )
end

template node['jmh_db']['watch_script']['name'] do
  source 'check_thread_sh.erb'
  mode 0700
  action :create
  variables(
    user: node['jmh_db']['monitor']['user'],
    pass: node['jmh_db']['monitor']['password'],
    connection_limit: node['jmh_db']['watch_script']['connection_limit'],
    mysql_process: 'mysql-default',
    log: node['jmh_db']['watch_script']['log'],
    email: node['jmh_db']['watch_script']['email_addresses'],
    ruby_script: node['jmh_db']['watch_script']['ruby_script']
  )
end

#  flock creates a lock file so other things wont run while it is running
#  timeout will drop the job if it takes too long
cron 'check_mysql_process' do
  minute node['jmh_db']['watch_script']['cron_minutes']
  command "flock -w 15 /tmp/mysql_check.lck -c \"timeout 600 #{node['jmh_db']['watch_script']['name']}\" > " +
              "#{node['jmh_db']['watch_script']['log']} 2>&1"
  action node['jmh_db']['watch_script']['enable'] ? :create : :delete
end