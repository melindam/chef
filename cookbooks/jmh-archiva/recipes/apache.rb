include_recipe 'jmh-webserver'

jmh_webserver 'ebiz-repo-ssl' do
  apache_config node['jmh_archiva']['ebizrepo']['apache_config']
  action :install
end

jmh_webserver 'ebiz-repo' do
  apache_config node['jmh_archiva']['ebizrepo80']['apache_config']
  action :install
end
