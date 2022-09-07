
include_recipe 'jmh-webserver'

directory "#{File.join("/home", node['jmh_webserver']['vvisits_client']['user'], 'bin')}" do
  path File.join("/home", node['jmh_webserver']['vvisits_client']['user'] , 'bin')
  owner node['jmh_webserver']['vvisits_client']['user']
  group node['jmh_webserver']['vvisits_client']['group']
  mode '0755'
  action :create
end

template File.join("/home", node['jmh_webserver']['vvisits_client']['user'], 'bin', 'deploy_vvisits_client.sh') do
  source "vvisits_client/deploy_vvisits_client_sh.erb"
  owner node['jmh_webserver']['vvisits_client']['user']
  group node['jmh_webserver']['vvisits_client']['group']
  mode '0755'
  variables(
      :content_dir => node['jmh_webserver']['vvisits_client']['docroot_dir'],
      :path => node['jmh_webserver']['vvisits_client']['content_dir'],
      :home_dir => File.join("/home", node['jmh_webserver']['vvisits_client']['user'])
  )
end

vvisits_client_path = File.join(node['jmh_webserver']['vvisits_client']['docroot_dir'], node['jmh_webserver']['vvisits_client']['content_dir'])
directory "vvisits_client root content directory" do
  path vvisits_client_path
  owner node['jmh_webserver']['vvisits_client']['user']
  group node['jmh_webserver']['vvisits_client']['group']
  mode '0755'
  action :create
end