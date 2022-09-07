# SSO setup
#
# To use with an app, add the following directives
# <Location <<context>> >
#  AuthType openid-connect
#  Require valid-user
# <Location>
#
#
remote_file File.join(Chef::Config[:file_cache_path],node['jmh_webserver']['sso']['cjose_file']) do
  action :delete
end

yum_package 'cjose' do
  source File.join(Chef::Config[:file_cache_path],node['jmh_webserver']['sso']['cjose_file'])
  action :nothing
end

# Install openidc from S3
openidc_filename= File.basename(node['jmh_webserver']['sso']['openidc_mod_url'])
openidc_rpm_name= openidc_filename[/(.*)\.rpm/,1]
# If the current rpm is not installed, install it, else it is an upgrade
openidc_action = %x(rpm -qa | grep #{openidc_rpm_name}) ? :upgrade : :install

remote_file File.join(Chef::Config[:file_cache_path],openidc_filename) do
  action :delete
end

yum_package "mod_auth_openidc" do
  source File.join(Chef::Config[:file_cache_path],openidc_filename)
  action :nothing
  notifies :reload, 'service[apache2]', :delayed
end

apache_module 'auth_openidc' do
  enable false
  notifies :reload, 'service[apache2]', :delayed
end