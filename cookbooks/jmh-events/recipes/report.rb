
include_recipe "jmh-db::client"
package 'p7zip'
package 'mutt'

last_month = if node['jmh_events']['report']['date'] 
               node['jmh_events']['report']['date']
             else
               Date.today << 1
             end
             
sql_host = '127.0.0.1'
search(:node, node['jmh_events']['report']['events_search']) do |n|
      Chef::Log.debug("***This node is #{n.name}")
      sql_host = n['ipaddress']
end

reports_host = '127.0.0.1'
search(:node, node['jmh_events']['report']['scp_search']) do |n|
      Chef::Log.debug("***This node is #{n.name}")
      reports_host = n['ipaddress']
end


# drop user 'events_rundeck'@'192.168.168.103';
# create user 'events_rundeck'@'192.168.168.103' identified by 'password';
# grant select on events.* to 'events_rundeck'@'192.168.168.103';
# flush privileges;

template File.join(node['jmh_events']['report']['script_folder'],'event_user_report.sh') do
  source 'event_user_report_sh.erb'
  user node['jmh_events']['report']['user']
  group node['jmh_events']['report']['group']
  mode 0700
  action :create
  variables(
    month: last_month.month,
    year:  last_month.year,
    report_name: node['jmh_events']['report']['report_name'],
    report_folder: node['jmh_events']['report']['report_folder'],
    mysql_host: sql_host,
    mysql_password: node['jmh_events']['report']['mysql_password'],
    archive_password: node['jmh_events']['report']['archive_password'],
    rsa_file: node['jmh_events']['report']['rsa_file'],
    scp_user: node['jmh_events']['report']['scp_user'],
    scp_host: reports_host,
    scp_folder: node['jmh_events']['report']['scp_folder'],
    archive_url: node['jmh_events']['report']['archive_url'],
    email_address: node['jmh_events']['report']['email_address']
  )
end