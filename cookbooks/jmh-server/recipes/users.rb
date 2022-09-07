
include_recipe 'jmh-server::jmhbackup' unless node['platform_family'] == 'windows'

# Add the sysadmin group
users_manage 'sysadmin' do
  group_id 2300
  action [:remove, :create]
  not_if {node['platform_family'] == 'windows'}
end

# Need to add vagrant to the wheel group otherwise vagrant loses it rootability once we update sudo
execute "vagrant in wheel" do
  command "/usr/sbin/usermod -G wheel vagrant"
  only_if "grep vagrant /etc/passwd"
end

# Windows Setup
if node['platform_family'] == 'windows'
  search('windows_users') do |u|
    wu = EncryptedDataBagItem.load('windows_users',u['id'])
    next unless wu['windows']
    user wu['id'] do
      password wu['password']
    end
    group 'Administrators' do
      append true
      members [wu['id']]
      only_if {wu['groups'].include?("Administrators")}
    end
  end
end

# Add the devadmin group
users_manage "devadmin" do
  group_id 2301
  action [ :remove, :create ]
  not_if {node['platform_family'] == 'windows'}
end

# Add the dev contractors, no access to prod/stage
users_manage "devcontractor" do
  action [ :remove, :create ]
  only_if {['sbx'].include?(node['jmh_server']['environment'])}
  not_if {node['platform_family'] == 'windows'}
end

data_bag('users').each do |login|
  account_databag = data_bag_item('users', login)
  if %x(id #{account_databag['id']} 2> /dev/null).include?(account_databag['id'])
    ruby_block "Remove password expire for #{login}" do
      block do
         %x(chage -M #{node['jmh_server']['users']['password_expire_days']} #{account_databag['id']})
      end
      not_if { account_databag['shell'] == '/bin/false' }
    end
  end
end

# Take the jmh-server defaults and put them into sudo
node.normal['authorization']['sudo']['groups'] = node['jmh_server']['sudo']['groups']
node.normal['authorization']['sudo']['passwordless'] = node['jmh_server']['sudo']['passwordless']

include_recipe "sudo" unless node['platform_family'] == 'windows'

# Active Directory LDAP authconfig setup for Local JMH servers only
# TODO FIX with RHEL repo broken on ebiz19, 22, 24 servers
#
# if node['jmh_server']['jmh_local_server']
#   Chef::Log.info('*** LOCAL SERVER == KRB5 INSTALL CONFIG *** ')
#   %w(authconfig krb5-libs pam_krb5).each do |auth_pkg|
#     package auth_pkg do
#       action :install 
#     end
#   end  

#   execute "Setup LDAP auth" do
#     command "authconfig --enableshadow --enablemd5 --disablenis --disableldap --disableldapauth --enablekrb5 --krb5kdc=hsys.local:88 --krb5adminserver=hsys.local:464 --krb5realm=HSYS.LOCAL --enablekrb5kdcdns --disablewinbind --disablewins --disablehesiod --disablesssd --enablecache --enablelocauthorize --enablepamaccess --disablemkhomedir --updateall"
#     not_if "grep HSYS\.LOCAL /etc/krb5.conf"
#   end
  
#   template '/etc/krb5.conf' do
#     source 'krb5_conf.erb'
#     action :create
#     mode 0644
#   end
    
#   # Create user and update sudo for SNOW Discovery Account
#   user 'servnowdiscsvc' do
#     comment 'ServiceNow CMDB Implementation - EBIZuser'
#     manage_home true
#     home '/home/servnowdiscsvc'
#     shell '/bin/bash'
#   end
  
#   template '/etc/sudoers.d/servnowdiscsvc' do
#     source 'sudoers_servnowdiscsvc.erb'
#     mode 0440
#   end

# end
