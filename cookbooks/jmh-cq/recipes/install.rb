include_recipe 'jmh-cq::dependencies'
include_recipe 'jmh-cq::user'

# Downloads and installs CQ
directory node['cq']['jar_directory'] do
  recursive true
end

Chef::Log.info("OAK URL is #{node['cq']['oak']['url']}")
remote_file File.join(node['cq']['jar_directory'], node['cq']['oak']['jar_name']) do
  source node['cq']['oak']['url']
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
end

if node['cq']['install_content']
  node.normal['cq']['author']['install_content'] = true if node['recipes'].include?('jmh-cq::author')
  node.normal['cq']['publisher']['install_content'] = true if node['recipes'].include?('jmh-cq::publisher')
end

# Get FAD server URL
search(:node, "recipes:jmh-fad\\:\\:client AND chef_environment:#{node.environment}") do |n|
  node.default['cq']['fad_url'] = "http://#{n['ipaddress']}:#{node['jmh_fad']['client']['appserver']['port']}/fad"
end

profile_api_databag = EncryptedDataBagItem.load(node['jmh_myjmh']['profile_api']['data_bag'][0],node['jmh_myjmh']['profile_api']['data_bag'][1])
if profile_api_databag['basic_auth'][node['jmh_server']['environment']]
  node.default['cq']['profile_api_password'] = profile_api_databag['basic_auth'][node['jmh_server']['environment']]['username'] + ":" +
                                                 profile_api_databag['basic_auth'][node['jmh_server']['environment']]['password']
else
  node.default['cq']['profile_api_password'] = profile_api_databag['basic_auth']['default']['username'] + ":" +
                                                profile_api_databag['basic_auth']['default']['password']
end

jar_path = File.join(node['cq']['jar_directory'], node['cq']['cq_s3_key'])

jmh_utilities_s3_download jar_path do
  remote_path node['cq']['cq_s3_key']
  bucket node['cq']['aws']['s3_bucket']
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

node.normal['cq']['current_jar'] = jar_path
