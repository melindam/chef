
directory node['jmh_operations']['shared_folder']['root_directory'] do
  action :create
end

directory File.join(node['jmh_operations']['share_directory']) do
  owner 'root'
  group 'root'
  mode '0777'
end

include_recipe 'jmh-webserver'
include_recipe 'jmh-operations::ebiz_web_server'

template File.join(node['apache']['dir'], 'conf-available', 'shared_folder.conf') do
  source 'shared_folder_conf.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0600
  variables(
    :shared_folder => node['jmh_operations']['share_directory'],
    :legacy_apache => node['jmh_webserver']['apache']['legacy_apache']
  )
  notifies :restart, 'service[apache2]', :delayed
end

apache_config 'shared_folder'

directory File.join(node['jmh_operations']['share_directory'],'aem') do
  owner 'root'
  group 'root'
  mode '0755'
end

share_aem=File.join(node['jmh_operations']['share_directory'], 'aem', node['jmh_operations']['cq']['prod_packs']['folder_name'])

prodpack_dir_name=File.join(node['jmh_operations']['cq']['backup_dir'], node['jmh_operations']['cq']['prod_packs']['folder_name'])

link share_aem do
  to prodpack_dir_name
  link_type :symbolic
end

template File.join(node['jmh_operations']['share_directory'], 'aem', 'aem_install_local_content.sh') do
  source 'cq/aem_install_local_content.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0755'
  variables(
    :share_dir => File.join('share/aem', node['jmh_operations']['cq']['prod_packs']['folder_name']),
    :author_packages => node['cq']['author']['content_assets'],
    :publisher_packages => node['cq']['publisher']['content_assets']
)
end