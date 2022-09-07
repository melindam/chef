include_recipe 'jmh-operations::ebiz_web_server'

package 'subversion' do
    action :install
end

include_recipe 'apache2::mod_dav_svn'

directory node['subversion']['repo_dir'] do
  recursive true
  owner node['apache']['user']
  group node['apache']['user']
  mode '0755'
end

##  Encryption: openssl aes-256-cbc -in attack-plan.txt -out message.enc
#   Decryption:   openssl aes-256-cbc -d -in message.enc -out plain-text.txt
# openssl rand -base64 23

svn_bag = Chef::EncryptedDataBagItem.load('operations', 'subversion')
svn_creds = svn_bag['repos']

node['jmh_operations']['subversion']['repos'].each do |svnrepo|
  remote_file "#{Chef::Config[:file_cache_path]}/#{svnrepo}.tgz.enc" do
    source node['jmh_operations']['subversion']['repo_download_url'] + '/' + svnrepo + '.tgz.enc'
    owner 'root'
    group 'root'
    mode '0600'
    action :create
    not_if { ::File.exist?(File.join(node['subversion']['repo_dir'], svnrepo)) }
  end

  execute "decrypt file #{svnrepo}.tgz.enc" do
    command "openssl aes-256-cbc -d -in #{svnrepo}.tgz.enc -out #{svnrepo}.tgz -k '#{svn_creds[svnrepo]['passkey']}'"
    cwd Chef::Config['file_cache_path']
    action :run
    only_if { ::File.exist?(File.join(Chef::Config[:file_cache_path], "#{svnrepo}.tgz.enc")) }
  end

  file "#{Chef::Config[:file_cache_path]}/#{svnrepo}.tgz.enc" do
    action :delete
    only_if { ::File.exist?(File.join(node['subversion']['repo_dir'], svnrepo)) }
  end

  execute 'Extract SVN Module' do
    command "tar xzf #{Chef::Config[:file_cache_path]}/#{svnrepo}.tgz"
    cwd node['subversion']['repo_dir']
    creates File.join(node['subversion']['repo_dir'], svnrepo)
  end

  execute 'chown-repo' do
    command "chown -R apache.apache #{node['subversion']['repo_dir']}/#{svnrepo}"
    action :run
  end

  file "#{Chef::Config[:file_cache_path]}/#{svnrepo}.tgz" do
    action :delete
    only_if { ::File.exist?(File.join(node['subversion']['repo_dir'], svnrepo)) }
  end

  # only install one of your are testing
  break if Chef::Config[:solo] || node['test_run']
end

# search(:node, node['jmh_operations']['subversion']['crowd']['search']) do |n|
# crowd_server_ip = n['ipaddress'] if n.environment == node.environment
# end
crowd_server_ip = '127.0.0.1'
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, 'roles:jmh-crowd') do |n|
    next unless n.environment == node['jmh_operations']['prod_environment']
    crowd_server_ip = n['ipaddress']
  end
end

ops_bag = Chef::EncryptedDataBagItem.load('operations', 'secure')
crowd_apache_password = ops_bag['crowd_prod_apache_password']

template File.join(node['apache']['dir'], 'conf-available', 'subversion.conf') do
  cookbook 'jmh-crowd'
  source 'subversion_crowd_conf.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0600
  variables(
    :location => 'repos',
    :limits => 'GET PROPFIND OPTIONS REPORT',
    :svn_repo_root => node['subversion']['repo_dir'],
    :authname => 'Secure Ebiz Invite',
    :authtype => 'Basic',
    :crowdappname => node['jmh_operations']['subversion']['crowd']['app'],
    :crowdapppassword => crowd_apache_password,
    :crowdurl => "http://#{crowd_server_ip}:8095/crowd/",
    :require => 'valid-user',
    :authzuserauthoritative_enabled => node['jmh_webserver']['apache']['legacy_apache'] 
  )
  notifies :restart, 'service[apache2]', :delayed
end

apache_config 'subversion'
