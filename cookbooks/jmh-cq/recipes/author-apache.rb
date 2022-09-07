# Creates the apache server to server author
node.default['jmh_webserver']['listen'] = [80, 443]
include_recipe 'jmh-webserver'

# Figure out the apache server name from the environment
if node['cq']['author']['apache']['server_name'].empty?
  case node['jmh_server']['environment']
  when 'prod'
    node.normal['cq']['author']['apache']['server_name'] = 'author.johnmuirhealth.com'
  when 'stage'
    node.normal['cq']['author']['apache']['server_name'] = 'author-stage.johnmuirhealth.com'
  else
    node.normal['cq']['author']['apache']['server_name'] = 'author-dev.johnmuirhealth.com'
  end
end

node.normal['cq']['author']['apache80']['server_name'] = node['cq']['author']['apache']['server_name']
node.normal['cq']['author']['apache_ssl']['server_name']  = node['cq']['author']['apache']['server_name']


jmh_webserver 'author80' do
  apache_config node['cq']['author']['apache80']
  action :install
end

jmh_webserver 'author' do
  apache_config node['cq']['author']['apache_ssl']
  action :install
end
