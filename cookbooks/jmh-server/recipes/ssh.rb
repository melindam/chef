# Installs openssh_client for other ssh client applications including scp
yum_package "openssh-clients" do
  action :install
end

service 'sshd' do
  action :nothing
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  user 'root'
  group 'root'
  mode 0600
  variables(
    armor_server: node['jmh_server']['armor'],
    client_alive_interval: node['jmh_server']['ssh']['sshd_config']['client_alive_interval'],
    client_alive_count_max: node['jmh_server']['ssh']['sshd_config']['client_alive_count_max'],
    banner: '/etc/redhat-release',
    permit_root_login: node['jmh_server']['ssh']['sshd_config']['permit_root_login']
  )
  notifies :restart, 'service[sshd]', :delayed
end

# Update ssh_known_hosts_file to correct mode for reading by other users
file "/etc/ssh/ssh_known_hosts" do
  mode '0644'
end
