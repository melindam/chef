execute "Set Timezone" do
  command "timedatectl set-timezone #{node['tz']}"
  action :run
  not_if { node['platform_family'] == 'windows' }
end

include_recipe "ntp"

service 'ntpdate' do
  action :enable
  not_if { node['platform_family'] == 'windows' }
end

