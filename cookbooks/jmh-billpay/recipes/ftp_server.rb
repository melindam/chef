include_recipe 'iptables'

iptables_rule 'iptables_billpay'

package "vsftpd"

service "vsftpd" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

template "/etc/vsftpd/vsftpd.conf" do
  source "vsftpd_conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "vsftpd")
end

template "/etc/vsftpd/user_list" do
  source "user_list.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
     :users => [node['jmh_billpay']['ftp_server']['user']]
  )
  notifies :restart, resources(:service => "vsftpd")
end

# TODO password think does not work
user node['jmh_billpay']['ftp_server']['user'] do
  action :create
  shell "/bin/bash"
  manage_home true
  password node['jmh_billpay']['ftp_server']['password']
end

directory File.join('home',node['jmh_billpay']['ftp_server']['user'],'output') do
  action :create
  owner node['jmh_billpay']['ftp_server']['user']
  group node['jmh_billpay']['ftp_server']['group']
end
