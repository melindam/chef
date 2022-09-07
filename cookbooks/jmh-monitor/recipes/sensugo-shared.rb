
user node['sensugo']['user'] do
  comment 'Sensu Account'
  home '/opt/sensu'
  shell '/bin/false'
end

sensu_ctl 'default' do
  version node['jmh_monitor']['sensugo']['version']
  action [:install]
end

ca_cert_filepath = File.join(node['jmh_monitor']['sensugo']['cert_folder'],node['jmh_monitor']['sensugo']['ca_cert_name'])
caData = nil

node.default['sensugo']['sensu_server_ip'] = '127.0.0.1'
unless node['recipes'].include?('jmh-monitor::sensugo-backend')
  search(:node, "roles:#{node['jmh_monitor']['sensugo_server']['role']}") do |n|
    if node['jmh_server']['jmh_local_server']
      node.default['sensugo']['sensu_server_ip'] =  if n['cloud']
                                                      n['cloud']['public_hostname']
                                                    else
                                                      n['ipaddress']
                                                    end
    else
      node.default['sensugo']['sensu_server_ip'] = n['ipaddress']
    end
    caData = n['jmh_monitor']['sensugo']['ca_data']
    break
  end
end

directory node['jmh_monitor']['sensugo']['cert_folder'] do
  recursive true
  action :create
end

file File.join(node['jmh_monitor']['sensugo']['cert_folder'],node['jmh_monitor']['sensugo']['ca_cert_name']) do
  content caData
  owner node['sensugo']['user']
  group node['sensugo']['group']
  mode 0700
  action :create
  notifies :restart, "service[sensu-agent]", :delayed
end

execute 'Change Admin Password' do
  command "/usr/bin/sensuctl user change-password #{node['jmh_monitor']['sensugo']['admin_user']} " +
            "-c '#{node['jmh_monitor']['sensugo']['admin_password']}' " +
            "--new-password '#{node['jmh_monitor']['sensugo']['new_admin_password']}'"
  not_if { node['jmh_monitor']['sensugo']['admin_password'] == node['jmh_monitor']['sensugo']['new_admin_password'] }
  action :run
end


execute "Sensu-ctl configure" do
  command "/usr/bin/sensuctl configure --non-interactive " +
              "--trusted-ca-file #{ca_cert_filepath} " +
              "--insecure-skip-tls-verify " +
              "--username #{node['jmh_monitor']['sensugo']['admin_user']} " +
              "--password '#{node['jmh_monitor']['sensugo']['admin_password']}' " +
              "--url https://#{node['sensugo']['sensu_server_ip']}:#{node['jmh_monitor']['sensugo']['api_port'] }"
  sensitive true
  returns [0]
  action :run
end

#TODO create a sensu restart script for all
directory '/etc/sensu/checks' do
  owner node['sensugo']['user']
  group node['sensugo']['group']
  mode 0775
  action :create
end

template "/etc/sensu/checks/metric_memory_by_user.sh" do
  source "checks/metric_memory_by_user_sh.erb"
  owner node['sensugo']['user']
  group node['sensugo']['group']
  mode 0775
end
