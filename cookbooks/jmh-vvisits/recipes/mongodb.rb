
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

if node['jmh_vvisits']['api']['mongodb']['password'].nil?
  node.normal['jmh_vvisits']['api']['mongodb']['password'] = random_password
end

node.default['mongodb']['users'] = [
    {
        'username' => node['jmh_vvisits']['api']['mongodb']['username'],
        'password' => node['jmh_vvisits']['api']['mongodb']['password'],
        'roles' => %w( readWrite ),
        'database' => node['jmh_vvisits']['api']['mongodb']['database']
    }
]

include_recipe 'jmh-mongodb'

cron "send-reminders-vvisits" do
  minute '*/5'
  command "curl -k https://localhost:8521/vvisits/v1/sendReminders >> /dev/null 2>&1"
  action :create
end

cron "zoom-license-recovery" do
  minute '0'
  hour '*/1'
  command "curl -k https://localhost:8521/vvisits/v1/recoverZoomLicenses >> /usr/local/nodeapp/vvisits-logs/vvisits.log"
  action :create
end