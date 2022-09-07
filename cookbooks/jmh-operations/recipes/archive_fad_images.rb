include_recipe 'jmh-operations::default'

fad_server_list = []
fad_second_server_list = []

# Get list of FAD servers
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, node['jmh_operations']['fad']['search_query']) do |n|
    if node['jmh_operations']['fad']['backup_environments'].include?(n.environment)
      node_hash = {}
      node_hash['environment'] = n.environment
      node_hash['name'] = n.name
      node_hash['ipaddress'] = n['ipaddress']
      fad_server_list.push(node_hash)
      Chef::Log.info("Adding #{n.name} #{n['ipaddress']} to fad images backup list")
    else
      Chef::Log.debug("Skipping #{n.name} #{n['ipaddress']} for fad images")
    end
  end

  search(:node, node['jmh_operations']['fad']['secondary_query'] ) do |n|
    if node['jmh_operations']['fad']['backup_environments'].include?(n.environment)
      sec_node_hash = {}
      sec_node_hash ['environment'] = n.environment
      sec_node_hash['name'] = n.name
      sec_node_hash['ipaddress'] = n['ipaddress']
      fad_second_server_list.push(sec_node_hash)
      Chef::Log.info("Adding #{n['ipaddress']} to fad secondary server list")
    else
      Chef::Log.debug("Skipping #{n.name} #{n['ipaddress']} for fad secondary server list")
    end
  end
end

directory node['jmh_operations']['fad']['backup_dir'] do
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0755'
end

node['jmh_operations']['fad']['backup_environments'].each do |n|
  directory "#{node['jmh_operations']['fad']['backup_dir']}/#{n}" do
    owner node['jmh_operations']['backup']['user']
    group node['jmh_operations']['backup']['user']
    mode '0755'
  end
end

template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'archive_fad_images.sh') do
  source 'archive_fad_images_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
    :user => node['jmh_operations']['backup']['user'],
    :backup_dir => node['jmh_operations']['fad']['backup_dir'],
    :server_list => fad_server_list,
    :jmh_local => node['jmh_server']['jmh_local_server'],
    :remote_image_path => node['jmh_operations']['fad']['images_path'],
    :secondary_server_list => fad_second_server_list
  )
end

include_recipe 'jmh-webserver'
include_recipe 'apache2::mod_cgi'
include_recipe 'jmh-operations::ebiz_web_server'

template File.join(node['apache']['dir'], 'conf-available', 'fad_image_folder.conf') do
  source 'fad_image_folder_conf.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0600
  variables(
    :fad_folder => File.join(node['jmh_operations']['fad']['backup_dir'], node['jmh_operations']['fad']['backup_environments'][0]),
    :legacy_apache => node['jmh_webserver']['apache']['legacy_apache']
  )
  notifies :restart, 'service[apache2]', :delayed
end

apache_config 'fad_image_folder'
