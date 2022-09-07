# create a webserver for mobile download location
# to be included on tools01-prd01
# authentication passwd will be standard eBizness password
include_recipe 'jmh-webserver'

apache_config = if node['jmh_webserver']['apache']['legacy_apache']
                  node['jmh_archiva']['ebizrepo']['legacy_authz_core'].merge(node['jmh_archiva']['ebizrepo']['apache_config'])
                else
                  node['jmh_archiva']['ebizrepo']['apache_config']
                end

jmh_webserver 'ebiz-repo-ssl' do
  cookbook 'jmh-webserver'
  apache_config apache_config
end

jmh_webserver 'ebiz-repo' do
  cookbook 'jmh-webserver'
  apache_config apache_config
end

%w(/usr/local/webapps /usr/local/webapps/mobile).each do |newdir|
  directory newdir do
    action :create
    mode '0755'
  end
end

directory node['jmh_archiva']['app_download']['app_dir'] do
  group node['jmh_archiva']['app_download']['group']
  mode 0775
  action :create
end

app_databag = Chef::EncryptedDataBagItem.load(node['jmh_archiva']['app_download']['databag']['name'], node['jmh_archiva']['app_download']['databag']['item'])

# Create index.html front page
template File.join(node['jmh_archiva']['app_download']['app_dir'], 'index.html') do
  source 'mobile_download.index.html.erb'
  user node['apache']['user']
  group node['apache']['group']
  mode 0600
  variables(
    :user => app_databag['users']['jmh']['user'],
    :passwd => app_databag['users']['jmh']['passwd'],
    :server => node['jmh_archiva']['ebizrepo']['apache_config']['server_name']
  )
  action :create
end

node['jmh_archiva']['app_download']['file_names'].each do |appfile|
  file File.join(node['jmh_archiva']['app_download']['app_dir'], appfile) do
    group node['jmh_archiva']['app_download']['group']
    mode 0664
    action :touch
  end
end


# Create basic authentication in front of apache
template node['jmh_archiva']['app_download']['authuserfile'] do
  source 'authuserfile.erb'
  user node['apache']['user']
  group node['apache']['group']
  mode 0600
  variables(
    :users => app_databag['users']
  )
  action :create
end
