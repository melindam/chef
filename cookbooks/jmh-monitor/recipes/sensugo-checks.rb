
unless node['recipes'].include?("jmh-monitor::sensugo-backend")
  Chef::Application.fatal!("You cannot install checks on a server that has no sensugo backend")
end

include_recipe 'jmh-monitor::sensugo-shared'

sensu_check 'check-cpu' do
  command 'check-cpu.rb '
  cron '* * * * *'
  subscriptions %w( base)
  handlers %w( email-handler)
  runtime_assets ['sensu-plugins/sensu-plugins-cpu-checks','sensu/sensu-ruby-runtime']
  publish true
  timeout 15
  annotations(
      'fatigue_check/occurrences': '10',
      'fatigue_check/interval': '600',
      'fatigue_check/allow_resolution': 'true')
  action :create
  notifies :restart, 'service[sensu-backend]', :delayed
end

metrics_cpu = [ {name: "metrics-cpu", command: "metrics-cpu.rb"},
                {name: "metrics-cpu-user-pct", command: "metrics-user-pct-usage.rb"}
              ]
metrics_cpu.each do | cpumetric |
  sensu_check cpumetric[:name] do
    command cpumetric[:command]
    interval 60
    subscriptions %w( base)
    handlers %w( graphite-handler)
    runtime_assets ['sensu-plugins/sensu-plugins-cpu-checks','sensu/sensu-ruby-runtime']
    publish true
    timeout 15
    high_flap_threshold 60
    low_flap_threshold 20
    output_metric_format "graphite_plaintext"
    output_metric_handlers ["graphite"]
    action :create
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end


#TODO Property overrides
sensu_check 'check-disk-usage' do
  command 'check-disk-usage.rb -c 95 -w 85 -x cifs -i /tmp/omnibus/cache'
  cron '*/10 * * * *'
  subscriptions %w( base)
  handlers %w( email-handler)
  runtime_assets ['sensu-plugins/sensu-plugins-disk-checks','sensu/sensu-ruby-runtime']
  publish true
  timeout 15
  annotations(
      'fatigue_check/occurrences': '1',
      'fatigue_check/interval': '600',
      'fatigue_check/allow_resolution': 'true')
  action :create
  notifies :restart, 'service[sensu-backend]', :delayed
end

# now = Time.now
# business_start = Time.new(now.year, now.month, now.day, 14)
# business_end = Time.new(now.year, now.month, now.day, 15)

sensu_check 'check_iptables' do
  command "check-cmd.rb -c 'service iptables status' -s 0 "
  interval 60
  subscriptions %w( base default)
  handlers %w( email-handler)
  annotations(
      'fatigue_check/occurrences': '1',
      'fatigue_check/interval': '600',
      'fatigue_check/allow_resolution': 'true')
  runtime_assets ['sensu-plugins/sensu-plugins-process-checks','sensu/sensu-ruby-runtime']
  publish true
  timeout 15
  # subdue(days: { all: [{ begin: business_start.strftime("%I:%M %p"), end: business_end.strftime("%I:%M %p") }] })
  action :create
  notifies :restart, 'service[sensu-backend]', :delayed
end

sensu_check 'check_memory_percent' do
  command "check-memory-percent.rb -w 90 -c 99 -p "
  interval 90
  subscriptions %w( base)
  handlers %w( email-handler)
  runtime_assets ['sensu-plugins/sensu-plugins-memory-checks','sensu/sensu-ruby-runtime']
  publish true
  timeout 15
  subdue(days: { all: [{ begin: '12:00 AM', end: '11:59 PM' },
                       { begin: '11:00 PM', end: '1:00 AM' }] })
  annotations(
      'fatigue_check/occurrences': '10',
      'fatigue_check/interval': '600',
      'fatigue_check/allow_resolution': 'true'
  )
  action :create
  notifies :restart, 'service[sensu-backend]', :delayed
end

memory_checks = [ {name:"metrics_memory_graphite", command:"metrics-memory.rb"}]
memory_checks.each do |metric|
  sensu_check metric[:name] do
    command metric[:command]
    interval 80
    subscriptions %w( base )
    # subscriptions %w( inactive )
    handlers %w( graphite-handler)
    runtime_assets ['sensu-plugins/sensu-plugins-memory-checks','sensu/sensu-ruby-runtime']
    publish true
    timeout 15
    output_metric_format "graphite_plaintext"
    output_metric_handlers ["graphite"]
    action :create
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end

# Check http
http_checks = data_bag_item(node['jmh_monitor']['sensu_checks']['databag'], 'check_http')
http_checks['checks'].each do |ccheck|
  checkURL = URI(ccheck['options']['-u'])
  path = if checkURL.query
           checkURL.path + "?" + checkURL.query
         else
           checkURL.path
         end
  handler = if ccheck['subscribers'].include?("cq-publisher") || ccheck['subscribers'].include?("cq-author")
              ['aem-email-handler']
            else
              ['email-handler']
            end
  sensu_check "check_http_#{ccheck['name']}" do
    command "check_http -H #{checkURL.host} -p #{checkURL.port} -u #{path} -t 60 -j GET #{ "-S" if checkURL.scheme == 'https'}"
    if ccheck['cron']
      cron ccheck['cron']
    elsif ccheck['interval']
      interval ccheck['interval']
    else
      interval 60
    end
    # interval ccheck['interval'] ? ccheck['interval'] : 60
    subscriptions ccheck['subscribers']
    handlers handler
    runtime_assets ['sensu/monitoring-plugins']
    publish true
    timeout 30
    annotations(
        'fatigue_check/occurrences': ccheck['occurences'] ? "#{ccheck['occurences']}" : '1',
        'fatigue_check/interval': '600',
        'fatigue_check/allow_resolution': 'true',
        'sensu.io/plugins/email/config/toEmail': ccheck['mail_to'] ? "#{ccheck['mail_to']}" : "#{node['jmh_monitor']['sensugo']['default_email_addresses']}"
    )
    action :create
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end

#findadoctorabudayeh

# new method for checks
http_sensugo_checks = data_bag_item(node['jmh_monitor']['sensu_checks']['databag'], 'check_http_sensugo')
http_sensugo_checks['checks'].each do |ccheck|
  sensu_check "check_http_#{ccheck['name']}" do
    command "check_http #{ccheck['options']}"
    interval ccheck['interval'] ? ccheck['interval'] : 60
    subscriptions ccheck['subscribers']
    handlers ccheck['handlers'] ? ccheck['handlers'] : %w( email-handler)
    runtime_assets ['sensu/monitoring-plugins']
    publish true
    timeout 30
    annotations(
        'fatigue_check/occurrences': ccheck['occurences'] ? "#{ccheck['occurences']}" : '1',
        'fatigue_check/interval': '600',
        'fatigue_check/allow_resolution': 'true',
        'sensu.io/plugins/email/config/toEmail': ccheck['mail_to'] ? "#{ccheck['mail_to']}" : "#{node['jmh_monitor']['sensugo']['default_email_addresses']}"
    )
    action :create
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end

procs_checks = data_bag_item(node['jmh_monitor']['sensu_checks']['databag'], 'check_procs')
procs_checks['checks'].each do |pcheck|
  sensu_check pcheck['name'] do
    command pcheck['command']
    interval pcheck['interval'] ? pcheck['interval'] : 60
    subscriptions pcheck['subscribers']
    handlers pcheck['handlers'] ? pcheck['handlers'] : %w( email-handler)
    runtime_assets ['sensu/monitoring-plugins']
    publish true
    timeout 15
    annotations(
        'fatigue_check/occurrences': pcheck['occurences'] ? "#{pcheck['occurences']}" : '1',
        'fatigue_check/interval': '600',
        'fatigue_check/allow_resolution': 'true',
        'sensu.io/plugins/email/config/toEmail': pcheck['mail_to'] ? "#{pcheck['mail_to']}" : "#{node['jmh_monitor']['sensugo']['default_email_addresses']}"
    )
    action :create
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end

mysql_metrics = [ {name:"metrics_mysql_graphite", command:"metrics-mysql-graphite.rb" },
                  {name:"metrics_mysql_processes", command:"metrics-mysql-processes.rb" }
                ]
mysql_metrics.each do |metric|
  mysql_options = "-i /etc/sensu/my.cnf"
  sensu_check metric[:name] do
    command "#{metric[:command]} -h 127.0.0.1 #{mysql_options}"
    interval 60
    # subscriptions %w( inactive )
    subscriptions %w( mysql )
    handlers %w( graphite-handler)
    runtime_assets ['sensu-plugins/sensu-plugins-mysql','sensu/sensu-ruby-runtime']
    publish true
    timeout 15
    output_metric_format "graphite_plaintext"
    output_metric_handlers ["graphite"]
    action :create
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end

sensu_check "metrics-ebiz24-ping" do
  command "metrics-ping.rb --host 172.23.200.18 --count 4 --timeout 60"
  interval 60
  subscriptions ['sensu-aws', 'sensu-armor']
  # subscriptions ['inactive']
  handlers %w( graphite-handler)
  runtime_assets ['sensu-plugins/sensu-plugins-network-checks','sensu/sensu-ruby-runtime']
  publish true
  timeout 15
  output_metric_format "graphite_plaintext"
  output_metric_handlers ["graphite"]
  action :create
  notifies :restart, 'service[sensu-backend]', :delayed
end


# Own Checks

directory '/etc/sensu/plugins' do
  owner node['sensugo']['user']
  group node['sensugo']['group']
  mode 0775
end

template '/etc/sensu/plugins/check-soap.sh' do
  source 'plugins/check_soap.erb'
  owner node['sensugo']['user']
  group node['sensugo']['group']
  mode 0770
end

soap_checks = data_bag_item(node['jmh_monitor']['sensu_checks']['databag'], 'check_soap')
soap_checks['checks'].each do |scheck|
  optionlist = ""
  scheck['options'].each do |option|
    optionlist += "\"#{option}\" "
  end

  sensu_check "check_soap_#{scheck['name']}" do
    command "/bin/sh /etc/sensu/plugins/check-soap.sh #{optionlist}"
    interval scheck['interval'] ? scheck['interval'] : 60
    subscriptions scheck['subscribers']
    handlers scheck['handlers'] ? scheck['handlers'] : %w( email-handler)
    publish true
    timeout 30
    annotations(
        'fatigue_check/occurrences': scheck['occurences'] ? "#{scheck['occurences']}" : '1',
        'fatigue_check/interval': '600',
        'fatigue_check/allow_resolution': 'true',
        'sensu.io/plugins/email/config/toEmail': scheck['mail_to'] ? "#{scheck['mail_to']}" : "#{node['jmh_monitor']['sensugo']['default_email_addresses']}"
    )
    action :create
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end

template '/etc/sensu/plugins/check-secure-rest.sh' do
  source 'plugins/check_secure_rest.erb'
  owner node['sensugo']['user']
  group node['sensugo']['group']
  mode 0770
end

secure_rest_checks = data_bag_item(node['jmh_monitor']['sensu_checks']['databag'], 'check_secure_rest')
secure_rest_checks['checks'].each do |rcheck|
  optionlist = ""
  rcheck['options'].each do |option|
    optionlist += "\"#{option}\" "
  end

  sensu_check "check_secure_rest_#{rcheck['name']}" do
    command "/bin/sh /etc/sensu/plugins/check-secure-rest.sh #{optionlist}"
    interval rcheck['interval'] ? rcheck['interval'] : 60
    subscriptions rcheck['subscribers']
    handlers rcheck['handlers'] ? rcheck['handlers'] : %w( email-handler)
    publish true
    timeout 30
    annotations(
        'fatigue_check/occurrences': rcheck['occurences'] ? "#{rcheck['occurences']}" : '1',
        'fatigue_check/interval': '600',
        'fatigue_check/allow_resolution': 'true',
        'sensu.io/plugins/email/config/toEmail': rcheck['mail_to'] ? "#{rcheck['mail_to']}" : "#{node['jmh_monitor']['sensugo']['default_email_addresses']}"
    )
    action :create
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end

sensu_check "metric_memory_by_user" do
  command "/etc/sensu/checks/metric_memory_by_user.sh"
  interval 120
  # subscriptions %w( inactive)
  subscriptions %w( base)
  handlers %w( graphite-handler)
  publish true
  output_metric_format "graphite_plaintext"
  output_metric_handlers ["graphite"]
  timeout 15
  action :create
  # notifies :restart, 'service[sensu-backend]', :delayed
end

# remove old checks
node['jmh_monitor']['sensugo']['check_removal'].each do |check_name|
  sensu_check check_name do
    action :delete
    notifies :restart, 'service[sensu-backend]', :delayed
  end
end

# still left to do
# dont check cq for certain times
#

# Checks still out there
# metrics apache
# ssh?
# clean up checks
#
#
# When done
# remove
# check mychart proxy
## remove databags check_general, metric_jmx, redis, ssh?
## remove checks check_cmd, check_general, check_httpd, sensu_checks
## remove handlers folder in cookbook
## remove handlers plugins check-disk, check_cmd, check_http, check_procs , java_checkperm,
# update
## check_httpd to sensugo_http
