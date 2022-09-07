node.default['jmh_webserver']['listen'] = [80]
include_recipe 'jmh-webserver'

jmh_webserver 'ebiztools' do
  apache_config node['jmh_operations']['web_server']['apache_config80']
end

include_recipe 'apache2::mod_cgi'

include_recipe 'jmh-crowd::apache_authentication_module'

directory File.join(node['jmh_operations']['web_server']['apache_config80']['docroot'], 'images') do
  user node['apache']['user']
  group node['apache']['group']
  action :create
end

images = %w(bullet.png header_commit.png logo_jmh.gif)

images.each do |fileimage|
  cookbook_file File.join(node['jmh_operations']['web_server']['apache_config80']['docroot'], 'images', fileimage) do
    source fileimage
    cookbook 'jmh-operations'
    user node['apache']['user']
    group node['apache']['group']
    mode 0644
  end
end

awstats_list = []
if node['recipes'].include?('jmh-operations::awstats')
  data_bag_item('operations', node['jmh_operations']['awstats']['servers_databag'])['servers'].each do |awserver|
    awstats_list.push(awserver['name'])
  end
end

template File.join(node['jmh_operations']['web_server']['apache_config80']['docroot'], 'index.html') do
  source 'index_html.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode '0644'
  variables(
    :show_subversion => node['recipes'].include?('jmh-operations::subversion') ? true : false,
    :show_fad_images => node['recipes'].include?('jmh-operations::archive_fad_images') ? true : false,
    :show_crowd => node['roles'].include?('jmh-ebiz-crowd') ? true : false,
    :show_shared_folder => node['recipes'].include?('jmh-operations::shared_folder') ? true : false,
    :show_reports => node['recipes'].include?('jmh-operations::reports') ? true : false,
    :awstats_list => awstats_list
  )
end

icheck = JmhEpic.get_interconnect_check_pages(node)

template File.join('/var/www/cgi-bin', 'check_interconnect.cgi') do
  source 'check_interconnect_cgi.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode '0755'
  variables(
    insecure_checks: icheck['insecure'],
    secure_checks: icheck['secure'],
    mcm_checks: icheck['mcm'],
    basic_auth: node['jmh_operations']['interconnect_check']['basic_auth']
  )
end

template File.join(node['apache']['dir'], 'conf-available', 'cgi-bin.conf') do
  source 'cgi_folder_conf.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0600
  variables(
    :legacy_apache => node['jmh_webserver']['apache']['legacy_apache']
  )
  notifies :restart, 'service[apache2]', :delayed
end

template File.join('/var/www/html','install_java_certs.sh') do
  cookbook 'jmh-java'
  source 'install_java_certs_sh.erb'
  action :create
end

apache_config 'cgi-bin'
