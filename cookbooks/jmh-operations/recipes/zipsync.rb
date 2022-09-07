
include_recipe 'jmh-myjmh::myjmh_command'

# install java
jmh_java_install "install java for zipsync" do
  version node['jmh_operations']['zipsync']['java_version']
  action :install
end

template File.join(node['jmh_myjmh']['myjmh_command']['install_dir'],"zipCodeSync.sh") do
  source 'zipcode_sync_sh.erb'
  owner node['jmh_server']['backup']['username']
  group node['jmh_server']['backup']['group']
  mode '0700'
  variables(
    java_home:  JmhJavaUtil.get_java_home(node['jmh_operations']['zipsync']['java_version'],node),
    script_dir: node['jmh_myjmh']['myjmh_command']['install_dir'],
    max_update_length: node['jmh_operations']['zipsync']['max_update_length'],
    local_log_file: File.join(node['jmh_myjmh']['myjmh_command']['install_dir'],'myjmh-command.log'),
    properties_file: File.join(node['jmh_myjmh']['myjmh_command']['install_dir'], node['jmh_myjmh']['myjmh_command']['properties_file']),
    db_host: node['jmh_myjmh']['myjmh_command']['db_hostname'],
    db_name: node['jmh_myjmh']['db']['database'],
    db_user: node['jmh_myjmh']['myjmh_command']['db_user'],
    db_password: node['jmh_myjmh']['myjmh_command']['db_password']
  )
  action :create
end

cron 'myjmh-command-zip-sync' do
  hour '5'
  minute '10'
  weekday "*"
  user "root"
  command File.join(node['jmh_myjmh']['myjmh_command']['install_dir'],"zipCodeSync.sh")
end

