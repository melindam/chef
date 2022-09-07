
## Java
node['jmh_bamboo']['java']['versions'].each do |java_version|
  jmh_java_install 'install java' do
    version java_version
    action :install
  end
end

%w(unzip git).each do |pack|
  package pack do
    action :install
  end
end

### Executables needed for bamboo
node['jmh_bamboo']['executables'].each do |executable|
  ark "ark_#{executable['app_name']}" do
    name executable['app_name']
    url executable['url']
    action :put
    not_if { ::File.exist?("/usr/local/#{executable['app_name']}") }
  end
end

# Maven Dependencies
directory File.join('home', node['jmh_bamboo']['run_as'], '.m2') do
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0755
end

bamboo_secure = Chef::EncryptedDataBagItem.load('credentials', 'bamboo')
template File.join('home', node['jmh_bamboo']['run_as'], '.m2', 'settings.xml') do
  source 'settings_xml.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0644
  variables(
    :archiva_user => 'bamboo',
    :archiva_password => bamboo_secure['archiva_pass'],
    :server_name => 'https://ebizrepo.johnmuirhealth.com/archiva/repository/releases-and-snapshots'
  )
end

# To create the jdk7 compiling, we need to skip ssl.  ugh!
archiva_server_ip = 'localhost'
search(:node, node['jmh_bamboo']['mvn']['archiva_server_recipe']) do |n|
  archiva_server_ip =  case
                       when n['ipaddress'] == node['ipaddress']
                         '127.0.0.1'
                         # this occurs when it is a local server and does not use the vpn
                       when n['cloud'] && node['jmh_server']['no_awsvpn_traffic']
                         n['cloud']['public_ipv4']
                       else
                         n['ipaddress']
                       end
end
template File.join('home', node['jmh_bamboo']['run_as'], '.m2', 'settings.jdk7.xml') do
  source 'settings_xml.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0644
  variables(
      :archiva_user => 'bamboo',
      :archiva_password => bamboo_secure['archiva_pass'],
      :server_name => "http://#{archiva_server_ip}:8080/archiva/repository/releases-and-snapshots"
  )
end

include_recipe 'jmh-bamboo::nodejs'

%w(bin whitesource plans).each do |dirs|
  directory File.join('home', node['jmh_bamboo']['run_as'], dirs) do
    owner node['jmh_bamboo']['run_as']
    group node['jmh_bamboo']['run_as']
    mode 0755
  end
end

# Whitesource
template File.join('home', node['jmh_bamboo']['run_as'], 'whitesource','wss-unified-agent.config') do
  source 'wss-unified-agent_config.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0644
  action :create
end

remote_file File.join('home', node['jmh_bamboo']['run_as'], 'whitesource',File.basename(node['jmh_bamboo']['whitesource']['jar_url'])) do
  source node['jmh_bamboo']['whitesource']['jar_url']
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0644
  action :create
end

# Scripts
template '/home/bamboo/bin/checkURL.sh' do
  source 'checkURL_sh.erb'
  mode 0755
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  action :create
end

template '/home/bamboo/bin/checkURLString.sh' do
  source 'checkURLString_sh.erb'
  mode 0755
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  action :create
end

template '/home/bamboo/bin/checkProfileApi.sh' do
  source 'checkProfileApi_sh.erb'
  mode 0755
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  action :create
  variables(
    profile_data_bag: Chef::EncryptedDataBagItem.load(node['jmh_myjmh']['profile_api']['data_bag'][0], node['jmh_myjmh']['profile_api']['data_bag'][1])
  )
end

chef_gem 'rest-client'
template File.join('home', node['jmh_bamboo']['run_as'], 'bin/update_lb_pool_rb.rb') do
  source 'update_lb_pool_rb.erb'
  mode 0700
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  variables(
    environment_creds: Chef::EncryptedDataBagItem.load('credentials', 'brocade').to_hash
  )
  action :create
end

template File.join('home', node['jmh_bamboo']['run_as'], 'bin/deploy_aem_bundle.rb') do
  source 'deploy_aem_bundle_rb.erb'
  mode 0700
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  variables(
      ruby_executable: '/opt/chef/embedded/bin/ruby'
  )
  action :create
end

template File.join('home', node['jmh_bamboo']['run_as'], 'bin/deploy_aem_package.rb') do
  source 'deploy_aem_package_rb.erb'
  mode 0700
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  variables(
      ruby_executable: '/opt/chef/embedded/bin/ruby'
  )
  action :create
end
