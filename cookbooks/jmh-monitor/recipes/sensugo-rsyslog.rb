
ruby_block "update journald.conf file for sensu logging" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/systemd/journald.conf")
    fe.search_file_delete_line(/#ForwardToSyslog/)
    fe.search_file_delete_line(/ForwardToSyslog\=no/)
    fe.insert_line_if_no_match(/ForwardToSyslog\=yes/,'ForwardToSyslog=yes')
    fe.write_file
  end
end

template "/etc/rsyslog.d/99-sensu-backend.conf" do
  cookbook 'jmh-monitor'
  source 'rsyslog_sensugo_conf.erb'
  action :create
  notifies :run, "execute[restart rsyslog]", :delayed
end

execute "restart rsyslog" do
  command "systemctl restart systemd-journald; systemctl restart rsyslog"
  action :nothing
end
