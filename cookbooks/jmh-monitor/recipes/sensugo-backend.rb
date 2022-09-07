include_recipe 'jmh-utilities::hostsfile_epic_servers'
include_recipe 'jmh-utilities::hostsfile_internal'

include_recipe 'iptables'
iptables_rule 'sensugo_iptables'

include_recipe 'jmh-monitor::sensugo-cert'

configs = { "state-dir": '/var/lib/sensu/sensu-backend',
            "log-level": 'debug',
            "agent-port": node['jmh_monitor']['sensugo']['agent_port'],
            "api-listen-address": "[::]:#{node['jmh_monitor']['sensugo']['api_port']}",
            "dashboard-port": "#{node['jmh_monitor']['sensugo']['web_port']}",
            "cache-dir": "/var/cache/sensu/sensu-backend",
            "cert-file": File.join(node['jmh_monitor']['sensugo']['cert_folder'],node['jmh_monitor']['sensugo']['cert_file_name']),
            "key-file": File.join(node['jmh_monitor']['sensugo']['cert_folder'],node['jmh_monitor']['sensugo']['key_file_name']),
            "trusted-ca-file": File.join(node['jmh_monitor']['sensugo']['cert_folder'],node['jmh_monitor']['sensugo']['ca_cert_name']),
            "insecure-skip-tls-verify": false}

sensu_backend 'default' do
  username node['jmh_monitor']['sensugo']['admin_user']
  password node['jmh_monitor']['sensugo']['admin_password']
  version node['jmh_monitor']['sensugo']['version']
  config configs
  action File::exists?('/etc/sensu/backend.yml') ? [:install] : [:install, :init]
  notifies :restart, 'service[sensu-backend]', :immediately
  notifies :restart, 'service[sensu-agent]', :delayed
end

directory "/etc/sensu/tls" do
  owner node['sensugo']['user']
  group node['sensugo']['group']
  mode 0700
end

service 'sensu-backend' do
  action :enable
end


include_recipe 'jmh-monitor::sensugo-shared'

node['jmh_monitor']['sensugo']['assets'].each do |asset|
  execute "install sensu asset #{asset}" do
    command "/usr/bin/sensuctl asset add #{asset}"
    not_if { system("/usr/bin/sensuctl asset info #{asset} > /dev/null") }
  end
end

# UTC_Time conversion.  We have to convert to UTC for it to work
now = Time.now
business_start = Time.new(now.year, now.month, now.day, node['jmh_monitor']['sensugo']['business_hour_start']).utc
business_end = Time.new(now.year, now.month, now.day, node['jmh_monitor']['sensugo']['business_hour_end']).utc

sensu_filter "business_hours_only" do
  filter_action 'allow'
  expressions [ "(hour(event.timestamp) >= #{business_end.hour} || hour(event.timestamp) <= #{business_start.hour})  || event.entity.labels['production'] == 'true'"]
end


sensu_filter 'fatigue-check-filter' do
  filter_action 'allow'
  expressions ["fatigue_check(event)"]
  runtime_assets ['nixwiz/sensu-go-fatigue-check-filter']
end

#  All AEM backup jobs start at 5am or 7pm everyday.  Filter silences the aem checks for 9 minutes twice a day.
# #  5am PDT = 12pm UTC
# #  7pm PDT = 2am UTC
aem_dev_start =  Time.new(now.year, now.month, now.day, 5).utc
aem_prod_start = Time.new(now.year, now.month, now.day, 19).utc

sensu_filter "aem-maintenance" do
  filter_action 'deny'
  expressions [ "(hour(event.timestamp) == #{aem_dev_start.hour} || hour(event.timestamp) == #{aem_prod_start.hour}) && " +
                "(minute(event.timestamp) >= 16 && minute(event.timestamp) <= 25)"
              ]
end

#  All FAD update backup jobs start at 3am or 6am everyday.  Filter silences the aem checks for 25 minutes twice a day.
# #  6am PDT = 2pm UTC
# #  3am PDT = 11am UTC
fad_stage_start =  Time.new(now.year, now.month, now.day, 6).utc
fad_prod_start = Time.new(now.year, now.month, now.day, 3).utc

sensu_filter "fad-maintenance" do
  filter_action 'deny'
  expressions [ "(hour(event.timestamp) == #{fad_stage_start.hour} || hour(event.timestamp) == #{fad_prod_start.hour}) && " +
                    "(minute(event.timestamp) >= 0 && minute(event.timestamp) <= 25)"
              ]
end

#  All SUP Update window starts at 5am everyday.  Filter silences the aem checks for 1 hour.
# #  5am PDT = 2pm UTC
sup_maintenance_hour =  Time.new(now.year, now.month, now.day, 5).utc

sensu_filter "sup-maintenance" do
  filter_action 'deny'
  expressions [ "(hour(event.timestamp) == #{sup_maintenance_hour.hour})"  ]
end

sensu_handler 'email-handler' do
  type 'pipe'
  command "sensu-email-handler -f #{node['jmh_monitor']['sensugo']['return_address']} " +
              "-t #{node['jmh_monitor']['sensugo']['default_email_addresses']} " +
              "-T /etc/sensu/email_template.txt " +
              "-s localhost " +
              "-a none  -i " +
              "-S '{{ .Check.State }} - {{ .Entity.Name }}/{{ .Check.Name }}'"
  runtime_assets ['sensu/sensu-email-handler']
  filters ['business_hours_only','not_silenced','is_incident','fatigue-check-filter']
  notifies :restart, 'service[sensu-backend]', :delayed
end

# for host keepalive
sensu_handler 'keepalive' do
  type 'pipe'
  command "sensu-pagerduty-handler -t #{node['jmh_monitor']['sensugo']['pagerduty_event_key']} "
  runtime_assets ['sensu/sensu-pagerduty-handler']
  filters ['business_hours_only','not_silenced','is_incident','fatigue-check-filter']
  notifies :restart, 'service[sensu-backend]', :delayed
end

sensu_handler 'aem-email-handler' do
  type 'pipe'
  command "sensu-email-handler -f #{node['jmh_monitor']['sensugo']['return_address']} " +
              "-t #{node['jmh_monitor']['sensugo']['default_email_addresses']} " +
              "-T /etc/sensu/email_template.txt " +
              "-s localhost " +
              "-a none  -i " +
              "-S '{{ .Check.State }} - {{ .Entity.Name }}/{{ .Check.Name }}'"
  runtime_assets ['sensu/sensu-email-handler']
  filters ['aem-maintenance','not_silenced','is_incident','fatigue-check-filter']
  notifies :restart, 'service[sensu-backend]', :delayed
end

sensu_handler 'fad-email-handler' do
  type 'pipe'
  command "sensu-email-handler -f #{node['jmh_monitor']['sensugo']['return_address']} " +
              "-t #{node['jmh_monitor']['sensugo']['default_email_addresses']} " +
              "-T /etc/sensu/email_template.txt " +
              "-s localhost " +
              "-a none  -i " +
              "-S '{{ .Check.State }} - {{ .Entity.Name }}/{{ .Check.Name }}'"
  runtime_assets ['sensu/sensu-email-handler']
  filters ['fad-maintenance','not_silenced','is_incident','fatigue-check-filter']
  notifies :restart, 'service[sensu-backend]', :delayed
end

sensu_handler 'sup-email-handler' do
  type 'pipe'
  command "sensu-email-handler -f #{node['jmh_monitor']['sensugo']['return_address']} " +
              "-t #{node['jmh_monitor']['sensugo']['default_email_addresses']} " +
              "-T /etc/sensu/email_template.txt " +
              "-s localhost " +
              "-a none  -i " +
              "-S '{{ .Check.State }} - {{ .Entity.Name }}/{{ .Check.Name }}'"
  runtime_assets ['sensu/sensu-email-handler']
  filters ['sup-maintenance','not_silenced','is_incident','fatigue-check-filter']
  notifies :restart, 'service[sensu-backend]', :delayed
end

sensu_handler 'pagerduty-handler' do
  type 'pipe'
  command "sensu-pagerduty-handler -t #{node['jmh_monitor']['sensugo']['pagerduty_event_key']} "
  runtime_assets ['sensu/sensu-pagerduty-handler']
  filters ['business_hours_only','not_silenced','is_incident','fatigue-check-filter']
  notifies :restart, 'service[sensu-backend]', :delayed
end

sensu_handler 'graphite' do
  type 'pipe'
  command "sensu-go-graphite-handler --prefix jmh --annotations short_dc -H localhost"
  runtime_assets ['fgouteroux/sensu-go-graphite-handler']
  filters ['has_metrics']
  timeout 5
end

template "/etc/sensu/email_template.txt" do
  source 'email_template_txt.erb'
  variables(
      sensugo_servername: node['jmh_monitor']['sensugo']['servername']
  )
  action :create
end

include_recipe 'jmh-monitor::sensugo-agent'
include_recipe 'jmh-monitor::sensugo-checks'
include_recipe 'jmh-monitor::sensugo-rsyslog'

logrotate_app "sensu-backend" do
  cookbook 'logrotate'
  path '/var/log/sensu/sensu-backend.log'
  frequency 'daily'
  rotate 14
  options %w(compress delaycompress nodateext missingok copytruncate)
end

# if it is down , try to restart it.
service 'sensu-backend' do
  action node['jmh_monitor']['sensugo']['restart_action']
  not_if { system( "curl https://localhost:#{node['jmh_monitor']['sensugo']['web_port']} -k") }
end