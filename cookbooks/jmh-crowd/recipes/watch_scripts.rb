

# Create Watch Script
template ::File.join('/root/bin', 'check_crowd.sh') do
  source 'check_crowd.erb'
  mode 0755
  user 'root'
  group 'root'
  variables(
    :hostname => 'localhost',
    :process_owner => 'crowd',
    :port => node['jmh_crowd']['ssl_port'],
    :check_page => node['jmh_crowd']['watch_script']['check_page'],
    :app_name => 'atlassian-crowd',
    :email => node['jmh_crowd']['watch_script']['email'],
    :restart_script => node['jmh_crowd']['watch_script']['restart_script'],
    :cfg_dir => node['jmh_crowd']['install']['current'],
    :cfg_file => 'crowd.cfg.xml',
    :log_file => '/root/check-crowd.log',
    :java_home => JmhJavaUtil.get_java_home(node['jmh_crowd']['java']['version'], node)
  )
end


# Flock - see if you can get that file within 15 seconds or fail out
# timeout 1200 - fail out the job after 1200 seconds
cron 'check_crowd' do
  minute '*/10'
  command "flock -w 15 /tmp/crowd_restart.lck -c \"timeout 1200 /root/bin/check_crowd.sh\" > " +
               "/root/croncheck_crowd.log 2>&1"
  action node['jmh_crowd']['watch_script']['enable'] ? :create : :delete
end
