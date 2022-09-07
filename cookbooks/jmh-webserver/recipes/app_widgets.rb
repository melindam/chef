# Used to get content in place for updates by bamboo

include_recipe 'jmh-webserver'

directory "#{File.join("/home", node['jmh_webserver']['app_widgets']['user'], 'bin')}" do
  path File.join("/home", node['jmh_webserver']['app_widgets']['user'] , 'bin')
  owner node['jmh_webserver']['app_widgets']['user']
  group node['jmh_webserver']['app_widgets']['group']
  mode '0755'
  action :create
end

template File.join("/home", node['jmh_webserver']['app_widgets']['user'], 'bin', 'deploy_app_widgets.sh') do
  source "app_widgets/deploy_app_widgets_sh.erb"
  owner node['jmh_webserver']['app_widgets']['user']
  group node['jmh_webserver']['app_widgets']['group']
  mode '0755'
  variables(
    :content_dir => node['jmh_webserver']['app_widgets']['docroot_dir'],
    :path => node['jmh_webserver']['app_widgets']['content_dir'], 
    :home_dir => File.join("/home", node['jmh_webserver']['app_widgets']['user'])
  )
end

template File.join("/home", node['jmh_webserver']['app_widgets']['user'], 'bin', 'deploy_video.sh') do
  source "app_widgets/deploy_video_sh.erb"
  owner node['jmh_webserver']['app_widgets']['user']
  group node['jmh_webserver']['app_widgets']['group']
  mode '0755'
  action :create
end

app_widgets_path = File.join(node['jmh_webserver']['app_widgets']['docroot_dir'], node['jmh_webserver']['app_widgets']['content_dir'])
directory "app_widgets root content directory" do
  path app_widgets_path 
  owner node['jmh_webserver']['app_widgets']['user']
  group node['jmh_webserver']['app_widgets']['group']
  mode '0755'
  action :create
end
