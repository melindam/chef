package "crontabs" do
  action :install
end

service "crond" do
  action :start
end

include_recipe "chef-client::cron" if node['jmh_server']['use_chef_cron']

systemd_service 'chef-client' do
  unit_description 'Run Chef-client at boot'
  after %w( syslog.target network.target nss-lookup.target ntpdate.service )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    exec_start "/opt/chef/bin/chef-client"
    type 'oneshot'
  end
end

service 'chef-client' do
  action :enable
end
