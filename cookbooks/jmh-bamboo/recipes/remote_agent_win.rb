# Set Java to Windows
node.default['java']['jdk_version'] = node['jmh_bamboo']['windows']['java']['jdk_version']
node.default['java']['install_flavor'] = node['jmh_bamboo']['windows']['java']['install_flavor']
node.default['java']['oracle']['accept_oracle_download_terms'] = node['jmh_bamboo']['windows']['java']['oracle']['accept_oracle_download_terms']
node.default['java']['java_home'] = node['jmh_bamboo']['windows']['java']['java_home']
node.default['java']['windows']['package_name'] = node['jmh_bamboo']['windows']['java']['package_name']
node.default['java']['windows']['url'] = node['jmh_bamboo']['windows']['java']['windows']['url']

include_recipe 'java::default' unless ::File.exists?(node['java']['java_home'])

# Set the hostfile for windows
bamboo_ip = '127.0.01'
if node['jmh_bamboo']['windows']['bamboo_ip']
  bamboo_ip = node['jmh_bamboo']['windows']['bamboo_ip']
else
  search(:node, 'recipes:jmh-bamboo\:\:install') do |n|
    bamboo_ip = n['ipaddress']
  end
end
node.default['jmh_bamboo']['windows']['bamboo_agent_install_url'] = "http://#{bamboo_ip}/bamboo/agentServer/" +
                                                                    "agentInstaller/" +
                                                                    "atlassian-bamboo-agent-installer-#{node['jmh_bamboo']['version']}.jar"
node.default['jmh_bamboo']['windows']['bamboo_agent_server_url'] = "http://#{bamboo_ip}/bamboo/agentServer"


hostsfile_entry bamboo_ip do
  hostname  node['jmh_bamboo']['server_name']
  aliases [node['jmh_bamboo']['server_alias']]
  unique    true
end

include_recipe 'git::windows'

windows_package "notepad+" do
  source "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v7.8.2/npp.7.8.2.Installer.x64.exe"
  action :install
end

# Install the packages needed for test cafe
windows_package "nodejs" do
  source node['jmh_bamboo']['windows']['nodejs_install_url']
  action :install
end

# batch 'install testcafe' do
#   code <<-EOH
#   setlocal enabledelayedexpansion
#   pushd "%~dp0"
#   set "PATH=%APPDATA%\\npm;%~dp0;%PATH%"
#   cd "C:\\Program Files (x86)\\nodejs"
#   npm install -g testcafe
#   EOH
# end

execute "install testcafe" do
  command "npm install -g testcafe --force"
  cwd "C:/Program Files (x86)/nodejs"
  action :run
end

directory node['jmh_bamboo']['windows']['bamboo_dir'] do
  action :create
end
agent_installer_path = File.join(node['jmh_bamboo']['windows']['bamboo_dir'],"atlassian-bamboo-agent-installer.jar")

remote_file agent_installer_path do
  source node['jmh_bamboo']['windows']['bamboo_agent_install_url']
  action :create
end

windows_zipfile node['jmh_bamboo']['windows']['bamboo_dir'] do
  source node['jmh_bamboo']['windows']['nssm']['url']
  action :unzip
end

service_created = system("sc query bamboo-remote-agent")

execute "install windows service" do
  command "\"#{node['jmh_bamboo']['windows']['java']['java_home']}\\bin\\java.exe\" -jar \"#{agent_installer_path}\" \"#{node['jmh_bamboo']['windows']['bamboo_agent_server_url']}\" installntservice"
  action service_created ? :nothing : :run
end

# sc query bamboo-remote-agent
# java -jar atlassian-bamboo-agent-installer-2.2-SNAPSHOT.jar http://bamboo-host-server:8085/agentServer <wrapper_command>
# java -jar atlassian-bamboo-agent-installer.jar http://172.23.203.207:8085/bamboo/agentServer installntservice
# java -jar atlassian-bamboo-agent-installer.jar http://172.23.203.207:8085/bamboo/agentServer uninstallntservice

# execute 'delete bamboo' do
#   command "sc delete bamboo-agent"
#   action :run
#   returns [0,1060]
#   only_if { node['jmh_bamboo']['windows']['bamboo_update'] }
# end
#

windows_service node['jmh_bamboo']['windows']['bamboo_service'] do
  action :start
end