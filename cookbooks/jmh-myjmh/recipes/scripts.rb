include_recipe 'jmh-tomcat::user'

# Create a hash to store our connection information
# Create local user to connect to DB for script
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.normal['jmh_myjmh']['profile']['db']['mrn_password'] = random_password unless node['jmh_myjmh']['profile']['db']['mrn_password']

jmh_db_mysql_local_user node['jmh_myjmh']['profile']['db']['mrn_username'] do
  username node['jmh_myjmh']['profile']['db']['mrn_username']
  password node['jmh_myjmh']['profile']['db']['mrn_password']
  database node['jmh_myjmh']['profile']['db']['database']
  privileges [:all]
  host_connection '127.0.0.1'
  action :create
end

# If encrypted drive
if node['recipes'].include?('jmh-encrypt::lukscrypt')
  directory File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'webapps') do
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode '0755'
    action :create
    notifies :create, 'link[Create Webapps Symlink]', :immediately
  end

  link 'Create Webapps Symlink' do
    target_file '/usr/local/webapps'
    to File.join(node['jmh_encrypt']['lukscrypt']['encrypted_directory'], 'webapps')
    link_type :symbolic
    action :nothing
  end
else
  directory 'Webapps dir for myjmh scripts' do
    owner node['jmh_tomcat']['user']
    group node['jmh_tomcat']['group']
    mode '0755'
    action :create 
  end
end 
  
# Setup needed directories  
node['jmh_myjmh']['scripts_dir'].each do |dirname|
  directory dirname do
    owner "tomcat"
    group "tomcat"
    mode "0775"
    action :create
  end
end
  
# Create MRN Merge Scripts
template '/usr/local/webapps/myjmh/scripts/myjmh_epic_rm_sftp_files.sh' do
  source 'myjmh_epic_rm_sftp_files.sh.erb'
  mode 0755
  user node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
end

template '/usr/local/webapps/myjmh/scripts/myjmh_epic_sftp.sh' do
  source 'myjmh_epic_sftp.sh.erb'
  mode 0755
  user node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
end

template '/usr/local/webapps/myjmh/scripts/myjmh_mrn_merge.sh' do
  source 'myjmh_mrn_merge.sh.erb'
  mode 0750
  user node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  variables(
    :db_user => node['jmh_myjmh']['profile']['db']['mrn_username'],
    :db_password => node['jmh_myjmh']['profile']['db']['mrn_password']
  )
end

include_recipe 'jmh-utilities::hostsfile_ssh1'

deploy_key_bag = Chef::EncryptedDataBagItem.load('deploy_keys', 'ebusiness_ssh1')

file 'ebusiness_id_rsa for myjmh' do
  path File.join('home', node['jmh_tomcat']['user'],  '.ssh', 'ebusiness_id_rsa')
  content deploy_key_bag['deploy_key']
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['user']
  mode 0600
end
