# server_apache.rb
include_recipe 'jmh-webserver'

jmh_webserver 'splunk' do
  apache_config node['jmh_splunk']['http']['config']
  action :install
end

jmh_webserver 'splunk' do
  apache_config node['jmh_splunk']['https']['config']
  action :install
end
