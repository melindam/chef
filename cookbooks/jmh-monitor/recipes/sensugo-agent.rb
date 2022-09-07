include_recipe 'jmh-monitor::sensugo-shared'

subscriptions = Array.new(node['jmh_monitor']['sensugo']['default_subscriptions'])
if node['jmh_monitor']['subscriptions']
  subscriptions.concat(node['jmh_monitor']['subscriptions'])
end

# # Add subscriptions that are tied to recipes.
auto_subscriptions = DataBagItem.load(node['jmh_monitor']['subscriptions_databag'][0],node['jmh_monitor']['subscriptions_databag'][1])

auto_subscriptions['subscriptions'].each do |r, s|
  next unless node['recipes'].include?("#{r}")
  if s.kind_of?(Array)
    subscriptions.concat(s)
  else
    subscriptions.push(s)
  end
end

# Used by mysql checks
template "/etc/sensu/my.cnf" do
  source 'sensugo_my_cnf.erb'
  owner node['sensugo']['user']
  group node['sensugo']['group']
  mode 0600
  variables(
      user: node['jmh_db']['monitor']['user'],
      password: node['jmh_db']['monitor']['password'] ? node['jmh_db']['monitor']['password'] : 'pass',
      host: '127.0.0.1'
  )
  action :create
  only_if { node['recipes'].include?("jmh-db::server") }
end

Chef::Log.warn("My sensugo subscriptions are: #{subscriptions.uniq()}")

sensu_agent 'default' do
  config("name": node['hostname'],
         "namespace": 'default',
         "subscriptions": subscriptions.uniq(),
         "backend-url": ["wss://#{node['sensugo']['sensu_server_ip']}:#{node['jmh_monitor']['sensugo']['agent_port'] }"],
         "trusted-ca-file": File.join(node['jmh_monitor']['sensugo']['cert_folder'],node['jmh_monitor']['sensugo']['ca_cert_name']),
         "labels": {
             "chef_environment": node.environment,
             "jmh_server_environment": node['jmh_server']['environment'],
             "production": node['jmh_monitor']['sensugo']['production_environment'].include?(node.environment) ? true : false
         },
         "keepalive-interval": 35,
         "keepalive-warning-timeout": 900,
         "keepalive-critical-timeout": 1200)
  version node['jmh_monitor']['sensugo']['version']
  action :install
  notifies :restart, "service[sensu-agent]", :delayed
end

service "sensu-agent" do
  action [:enable, :start]
end

include_recipe 'jmh-monitor::sensugo-rsyslog'

logrotate_app "sensu-agent" do
  cookbook 'logrotate'
  path '/var/log/sensu/sensu-agent.log'
  frequency 'daily'
  rotate 14
  options %w(compress delaycompress nodateext missingok copytruncate)
end