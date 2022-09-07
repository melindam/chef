::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.normal['openldap']['rootpw'] = random_password unless node['openldap']['rootpw']

include_recipe 'openldap::client'

package 'openldap-servers' do
  action :install
end

# Install SSL certs
canopy_databag = Chef::EncryptedDataBagItem.load(node['can_mycanopy']['openldap']['databag']['name'] ,node['can_mycanopy']['openldap']['databag']['item'] )
file node['openldap']['ssl_cert'] do
  content canopy_databag[node['can_mycanopy']['openldap']['databag']['cert_field_name']]
  action :create
  notifies :restart, 'service[slapd]', :delayed
end

file node['openldap']['ssl_key'] do
  content canopy_databag[node['can_mycanopy']['openldap']['databag']['key_field_name']]
  action :create
  notifies :restart, 'service[slapd]', :delayed
end

# adding custom schemas
# Deleting the template triggers a rebuild of openldap
node['can_mycanopy']['openldap']['custom_schemas'].each do |schema|
  cookbook_file File.join(node['openldap']['dir'], 'schema', schema) do
    source "openldap/#{schema}"
    cookbook 'can-mycanopy'
    mode 0644
    action :create
    notifies :delete,  "template[#{node['openldap']['dir']}/slapd.conf]", :immediately
  end
end

ruby_block 'Encode Root Password' do
  block do
    # tricky way to load this Chef::Mixin::ShellOut utilities
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
    command = "slappasswd -s '#{node['openldap']['rootpw']}'"
    command_out = shell_out(command)
    node.normal['openldap']['rootpw_encoded'] = command_out.stdout.chomp
  end
  action :create
  not_if { node['openldap']['rootpw_encoded'] }
end

include_recipe 'openldap::server'

# Setup command for shellout LDAP calls
admin_dn = "cn=#{node['openldap']['cn']},#{node['openldap']['basedn']}"
admin_bind_info = "-x -D '#{admin_dn}' -w '#{node['openldap']['rootpw']}'"
check_ldap_command = "ldapsearch #{admin_bind_info} -b '#{node['openldap']['basedn']}' '(cn=administrators)'"

cookbook_file File.join(Chef::Config[:file_cache_path], 'canopy-seed.ldif') do
  source 'openldap/canopy-seed.ldif'
  mode 0644
  action :create
end

ldif_com = "ldapadd #{admin_bind_info} -f #{File.join(Chef::Config[:file_cache_path], 'canopy-seed.ldif')}"
Chef::Log.warn("Ldif command is #{ldif_com}")
execute 'import ldif' do
  command ldif_com
  action Mixlib::ShellOut.new(check_ldap_command).run_command.error? ? :run : :nothing
end

# Set the passwords for the service accounts
node['can_mycanopy']['openldap']['service_accounts'].each_key do |sa|
  dn = node['can_mycanopy']['openldap']['service_accounts'][sa]['dn']
  unless node['can_mycanopy']['openldap']['service_accounts'][sa]['password']
    node.normal['can_mycanopy']['openldap']['service_accounts'][sa]['password'] = random_password
  end
  com = "ldappasswd -H ldap://localhost #{admin_bind_info} -s '#{node['can_mycanopy']['openldap']['service_accounts'][sa]['password']}' '#{dn}'"
  Chef::Log.debug("#{sa} command is : #{com}")
  execute "#{sa} password change" do
    command com
    sensitive true
    action :run
  end
end

iptables_rule 'openldap' do
  cookbook 'can-mycanopy'
  source 'iptables.erb'
  variables node['can_mycanopy']['openldap']['iptables']
  enable node['can_mycanopy']['openldap']['iptables']['portlist'].length != 0 ? true : false
end

# Setup back of LDAP server
include_recipe 'jmh-server::jmhbackup'
directory File.join(node['jmh_server']['backup']['home'],"ldapbackup") do
  user node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode 0755
end

directory '/root/bin' do
  action :create
end

template '/root/bin/backup_ldap.sh' do
  source 'backup_ldap_sh.erb'
  action :create
  mode 0744
  variables(
    :basedn => node['openldap']['basedn'],
    :backup_location => File.join(node['jmh_server']['backup']['home'],"ldapbackup"),
    :backup_days => 14
  )

end

cron "LDAP Backup" do
  minute '*/30'
  command "/root/bin/backup_ldap.sh  > /root/backup_ldap.log 2>&1"
  action :create
end
