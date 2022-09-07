::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
Chef::Log.debug("Config is #{node['jmh_fad']['client']['appserver']}")

include_recipe 'jmh-utilities::hostsfile_internal'
include_recipe 'jmh-utilities::hostsfile_www_servers'

if node['jmh_fad']['client']['db']['password'].nil?
  node.normal['jmh_fad']['client']['db']['password'] = random_password
end

jmh_db_user 'fad_client_user' do
 database node['jmh_fad']['client']['database']
 username node['jmh_fad']['client']['db']['username']
 password node['jmh_fad']['client']['db']['password']
 parent_node_query node['jmh_fad']['client']['db']['node_query'] unless node['recipes'].include?(node['jmh_fad']['client']['db']['local_recipe'])
 privileges node['jmh_fad']['client']['db']['privileges']
 connect_over_ssl node['jmh_fad']['client']['db']['connect_over_ssl']
end

# DB
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, node['jmh_fad']['client']['db']['node_query']) do |n|
    if n.environment == node.environment
      if n['ipaddress'] == node['ipaddress']
        node.default['jmh_fad']['db']['server'] = '127.0.0.1'
      else
        node.default['jmh_fad']['db']['server'] = n['ipaddress']
      end
      break
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for db server")
    end
  end
end

website_name = node['jmh_server']['global']['apache']['www']['server_name']
scheduling_context = node['jmh_fad']['client']['scheduling_cache_context']
scheduling_host = node['jmh_server']['global']['apache']['api']['server_name']

fad_catalina_properties =
    ["com.johnmuirhealth.fad.datasource.password=#{node['jmh_fad']['client']['db']['password']}",
     "com.johnmuirhealth.fad.datasource.url=jdbc:mysql://#{node['jmh_fad']['db']['server']}:3306/fad",
     "com.johnmuirhealth.fad.scheduleavailabilityurl=https://#{scheduling_host}/#{scheduling_context}/availability/fadProvidersByDateSorted?visitTypeId=551",
     "com.johnmuirhealth.fad.microcalendarurl=https://#{scheduling_host}/#{scheduling_context}/availability/microCalendarTimeSlotsForDoctors",
     "com.johnmuirhealth.fad.echoimportlocation=#{node['jmh_fad']['client']['upload']['folder']}/#{node['jmh_fad']['client']['upload']['import_file_name']}",
     "com.johnmuirhealth.fad.echofileuploadfolder=/usr/local/webapps/fad/manualimport",
     "com.johnmuirhealth.fad.profileimagelocation=#{node['jmh_fad']['client']['images_path']}",
     "com.johnmuirhealth.fad.googlemapsapikey=#{node['jmh_fad']['client']['google_maps_api_key']}",
     "com.johnmuirhealth.fad.googlemapsbackendapikey=#{node['jmh_fad']['client']['google_maps_backend_api_key']}",
     "com.johnmuirhealth.fad.absoluteserverurl=https://#{website_name}/fad",
     "com.johnmuirhealth.fad.fullsiteurl=https://#{website_name}",
     "com.johnmuirhealth.fad.omniture.account=#{node['jmh_fad']['client']['omniture']}",
     "com.johnmuirhealth.fad.tealuimprofile=#{node['jmh_fad']['client']['tealium']}",
     "com.johnmuirhealth.fad.aem.publish.host=https://#{website_name}",
     "com.johnmuirhealth.fad.aem.css.host=https://#{website_name}",
     "com.johnmuirhealth.fad.captcha.google.secret=#{node['jmh_fad']['client']['captcha_key']}",
     "com.johnmuirhealth.fad.numschedulingdays=#{node['jmh_fad']['client']['numschedulingdays']}"
     ]

if node['jmh_fad']['master_server']
  search(:node, node['jmh_fad']['client']['second_node_search_query']) do |n|
    next unless !n['jmh_fad']['master_server']
    fad_catalina_properties.push("com.johnmuirhealth.fad.adminupdateurl=http://#{n['ipaddress']}:8085/fad/api/refreshCache")
    break
  end
end

fad_rollout_array = []

if node['recipes'].include?('jmh-fad::db')
  fad_rollout_array = node['jmh_fad']['client']['appserver']['rollout_array']
else
  fad_rollout_array = [{ 'bamboo_name' => 'fad', 'war_name' => 'fad' }]
end


jmh_tomcat 'fad' do
  name node['jmh_fad']['client']['appserver']['name']
  java_version node['jmh_fad']['client']['appserver']['java_version']
  version node['jmh_fad']['client']['appserver']['version']
  max_heap_size node['jmh_fad']['client']['appserver']['max_heap_size']
  max_permgen node['jmh_fad']['client']['appserver']['max_permgen']
  port node['jmh_fad']['client']['appserver']['port']
  jmx_port node['jmh_fad']['client']['appserver']['jmx_port']
  ssl_port node['jmh_fad']['client']['appserver']['ssl_port']
  jmx_port node['jmh_fad']['client']['appserver']['jmx_port']
  iptables node['jmh_fad']['client']['appserver']['iptables']
  directories node['jmh_fad']['client']['appserver']['directories']
  rollout_array fad_rollout_array
  catalina_properties fad_catalina_properties
  action :create
end

directory node['jmh_fad']['client']['images_path'] do
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['user']
  mode 0775
end

directory node['jmh_fad']['client']['export_dir'] do
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['user']
  mode 0775
end

fad_databag = Chef::EncryptedDataBagItem.load("jmh_apps","fad")

# Create user need to ftp it over.
user node['jmh_fad']['client']['upload']['user'] do
  action :create
  password fad_databag['ssh_password_hash']
  shell '/bin/bash'
  manage_home true
  home File.join("/home", node['jmh_fad']['client']['upload']['user'])
end

group 'tomcat' do
  members ['jmhbackup', node['jmh_fad']['client']['upload']['user']]
  append true
  action :manage
end

ruby_block "Remove password expire for #{node['jmh_fad']['client']['upload']['user']}" do
  block do
     %x(chage -M #{node['jmh_server']['users']['password_expire_days']} #{node['jmh_fad']['client']['upload']['user']})
  end
end

template File.join('/home', node['jmh_fad']['client']['upload']['user'], '.bash_profile') do
  source 'bash_profile.erb'
  owner node['jmh_fad']['client']['upload']['user']
  group node['jmh_fad']['client']['upload']['user']
  mode 0644
end

directory node['jmh_fad']['client']['upload']['folder'] do
  recursive true
  owner node['jmh_fad']['client']['upload']['user']
  group node['jmh_fad']['client']['upload']['group']
  mode 0777
end

directory File.join(node['jmh_fad']['client']['upload']['folder'],"processed") do
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  mode 0755
end

fad_import_file = File.join(node['jmh_fad']['client']['upload']['folder'], node['jmh_fad']['client']['upload']['import_file_name'])

execute "change mode FAD import file" do
  command "chmod 0644 #{fad_import_file}"
  user "root"
  action :run
  only_if { ::File.exist?(fad_import_file) }
end

link File.join("/home", node['jmh_fad']['client']['upload']['user'], node['jmh_fad']['client']['upload']['symlink']) do
  link_type :symbolic
  to node['jmh_fad']['client']['upload']['folder']
  owner node['jmh_fad']['client']['upload']['user']
  group node['jmh_fad']['client']['upload']['group']
end

package 'wget' do
  action :nothing
end.run_action(:install)

# Get images from the ebiz-tools backup, if no images exist
execute "Get Images from Ebiz-tools" do
  command "wget -nd -r -l 1 -P #{node['jmh_fad']['client']['images_path']} -A jpeg,jpg,gif,tif,tiff,png #{node['jmh_fad']['client']['images_url']}"
  user "root"
  only_if { JmhFadUtil.url_available?(node['jmh_fad']['client']['images_url']) && Dir["#{node['jmh_fad']['client']['images_path']}/*"].empty? }
end

execute "chown image folder" do
  command "chown -R #{node['jmh_tomcat']['user']}.#{node['jmh_tomcat']['group']} #{node['jmh_fad']['client']['images_path']}/"
  user "root"
  action :run
end

execute "chmod image folder" do
  command "chmod 644 #{node['jmh_fad']['client']['images_path']}/*"
  user "root"
  action :run
end

template File.join( '/home', node['jmh_tomcat']['user'], 'bin/fad_base64_image_creator.sh') do
  source 'fad_base64_image_creator.sh.erb'
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  mode 0750
  variables(
      :db => node['jmh_fad']['client']['database'],
      :db_user => node['jmh_fad']['client']['db']['username'],
      :db_password => node['jmh_fad']['client']['db']['password'],
      :image_path => node['jmh_fad']['client']['images_path'],
      :export_dir => node['jmh_fad']['client']['export_dir']
    )
  end