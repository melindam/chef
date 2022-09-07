
jmh_java_install 'install java' do
  version node['jmh_pingfed']['pingfederate']['java_version']
  action :install
end

include_recipe 'pingfederate::engine_instance'

pingfederate_engine_dir = File.join(node['pingfed']['install_dir'], 'pingfederate-engine', node['pingfed']['filename'],'pingfederate')

# Include JMH specific pingfed config setup
cookbook_file File.join(pingfederate_engine_dir, '/server/default/conf', 'pingfederate.lic') do
  source "pingfederate/#{node['jmh_pingfed']['pingfederate']['license_file']}"
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode 0600
  action :create
  notifies :restart, 'service[pingfederate-engine]', :delayed
end

template File.join(pingfederate_engine_dir, '/etc/jetty-runtime.xml') do
  cookbook 'jmh-pingfed'
  source 'jetty-runtime_xml.erb'
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode '0644'
  variables(
      samesite_exclusion_agents: node['jmh_pingfed']['samesite_exclusions']
  )
  notifies :restart, 'service[pingfederate-engine]', :delayed
end

iptables_rule 'pingfederate-engine' do
  cookbook 'jmh-pingfed'
  source 'iptables.erb'
  variables node['jmh_pingfed']['pingfederate']['iptables']
  enable node['jmh_pingfed']['pingfederate']['iptables']['portlist'].length != 0 ? true : false
end

include_recipe "jmh-pingfed::common"

template '/home/pingfederate/bin/deploy_pingfed_templates.sh' do
  source 'deploy_pingfed_templates_sh.erb'
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode '0755'
end


cookbook_file '/home/pingfederate/src/pingfed-pcv.tar' do
  source "pingfederate/pingfed-pcv.tar"
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode '0644'
  action :create
end

bash 'extract_pingfed_pcv' do
  cwd ::File.join(pingfederate_engine_dir, 'sdk/plugin-src/')
  code <<-EOH
    tar xf /home/pingfederate/src/pingfed-pcv.tar
    chown -R pingfederate. pf-pcv-rest
    mv #{pingfederate_engine_dir}/sdk/plugin-src/pf-pcv-rest/src #{pingfederate_engine_dir}/sdk/plugin-src/pf-pcv-rest/java
  EOH
  not_if { ::File.exist?("#{pingfederate_engine_dir}/sdk/plugin-src/pf-pcv-rest") }
end

jmh_pingfed_install_plugins 'Install pingfederate-engine plugins' do
  plugin_array node['jmh_pingfed']['pingfederate']['plugins']
  install_path pingfederate_engine_dir
  resource_service 'pingfederate-console'
  action :install
end

# Set pingfederate user ID to not expire
execute 'pingfederate user not expire' do
  command "chage -M #{node['jmh_server']['users']['password_expire_days']} #{node['pingfed']['user']}"
end

# Include override file
template File.join(pingfederate_engine_dir, '/server/default/conf/language-packs/pingfederate-messages_en.properties') do
  source 'pingfederate-messages_en.properties.erb'
  owner node['pingfed']['user']
  group node['pingfed']['user']
  mode '0644'
  variables(
      :www_server_name => node['jmh_server']['global']['apache']['www']['server_name'],
      :api_server_name => node['jmh_server']['global']['apache']['api']['server_name'],
      :google_tracking_id => node['jmh_server']['global']['google_analytics_id'],
      :tealium_reportsuite_id => node['jmh_pingfed']['tealium_reportsuite_id'],
      :tealium_utag_env => node['jmh_pingfed']['tealium_utag_env']
  )
  notifies :restart, 'service[pingfederate-engine]', :delayed
end

include_recipe 'jmh-utilities::hostsfile_www_servers'