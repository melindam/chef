include_recipe 'jmh-cq::user'

directory node['cq']['share_directory'] do
  action :create
  mode 0775
  user node['cq']['maintenance_user']
  group node['cq']['group']
end

cq_databag = Chef::EncryptedDataBagItem.load(node['cq']['databag']['name'], node['cq']['databag']['item'])
node.normal['cq']['admin']['password'] = cq_databag[node['cq']['databag']['password_key']]

# Get Publisher Servers Ips
cq_pub_servers = []
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  cq_pub_servers = { 'arprod' => { 'name' => 'pubtest', 'ipaddress' => '127.0.0.1', 'nat_ip' => '127.0.0.1', 'environment' => 'arprod', 'jmh_environment' => 'prod' } }
else
  search(:node, node['cq']['scripts']['publisher_server_search']) do |n|
    found_server = {}
    found_server['name'] = n.name
    found_server['ipaddress'] = n['ipaddress']
    found_server['nat_ip'] = (n['firehost']) ? n['firehost']['nat_ip'] : nil
    found_server['password'] = n['cq']['admin']['password']
    cq_pub_servers.push(found_server)
    Chef::Log.info("Adding #{n.name}  #{n['ipaddress']} to cq publisher list")
  end
end

# Get Author Server Ips
cq_auth_servers = []
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  cq_auth_servers = { 'arprod' => { 'name' => 'authtest', 'ipaddress' => '127.0.0.1', 'nat_ip' => '127.0.0.1', 'environment' => 'arprod', 'jmh_environment' => 'prod' } }
else
  search(:node, node['cq']['scripts']['author_server_search']) do |n|
      found_server = {}
      found_server['name'] = n.name
      found_server['ipaddress'] = n['ipaddress']
      found_server['nat_ip'] = (n['firehost']) ? n['firehost']['nat_ip'] : nil
      found_server['password'] = n['cq']['admin']['password']
      cq_auth_servers.push(found_server)
      Chef::Log.info("Adding #{n.name}  #{n['ipaddress']} to cq author backup list")
  end
end

Chef::Application.fatal!("No author servers found!") if cq_auth_servers.size == 0
Chef::Application.fatal!("No publisher servers found!") if cq_pub_servers.size == 0

aws_creds = Chef::EncryptedDataBagItem.load(node['cq']['scripts']['aws_databag']['bag'], node['cq']['scripts']['aws_databag']['file'])

node['cq']['scripts']['script_array'].each do |scriptname|
  template File.join(node['cq']['bin_dir'], "#{scriptname}.sh") do
    source "packages/#{scriptname}.erb"
    mode 0700
    user node['cq']['maintenance_user']
    group node['cq']['group']
    variables(
      # bin_dir: ::File.join(node['cq']['base_directory'], 'bin'),
      :bin_dir => '/usr/local/cq/bin',
      :share_dir => node['cq']['share_directory'],
      :publisher_server => cq_pub_servers[0],
      :author_server => cq_auth_servers[0],
      :s3bucket => node['cq']['aws']['s3_bucket'],
      :author_packages => node['cq']['scripts']['author_packages'],
      :publisher_packages => node['cq']['scripts']['publisher_packages'],
      :jmh_local_server => node['jmh_server']['jmh_local_server'] ? node['jmh_server']['jmh_local_server'] : false,
      :access_id => aws_creds['iam']['chef']['access_key'],
      :access_key => aws_creds['iam']['chef']['secret_key']
    )
  end
end

# Author Install Scripts
cq_auth_servers.each do |auth_server|
  template File.join(node['cq']['bin_dir'], "install_author_assets.sh") do
    source 'packages/install_author_assets_sh.erb'
    mode 0700
    user node['cq']['maintenance_user']
    group node['cq']['group']
    variables(
      :share_dir => node['cq']['share_directory'],
      :author_server => cq_auth_servers[0],
      :author_packages => node['cq']['scripts']['author_packages']
    )
  end
end

# Publisher Install Scripts
cq_pub_servers.each do |pub_server|
  template File.join(node['cq']['bin_dir'], "install_publisher_assets.sh") do
    source 'packages/install_publisher_assets_sh.erb'
    mode 0700
    user node['cq']['maintenance_user']
    group node['cq']['group']
    variables(
      :share_dir => node['cq']['share_directory'],
      :publisher_servers => cq_pub_servers,
      :publisher_packages => node['cq']['scripts']['publisher_packages']
    )
  end
end