if node['jmh_webserver']['listen']
  unless node['jmh_webserver']['listen'].include?(83)
    ports = [83].concat(node['jmh_webserver']['listen'])
    node.default['jmh_webserver']['listen'] = ports
  end
else
  node.default['jmh_webserver']['listen'] = [83]
end


unless node['apache']['listen'].include?(83)
  node.default['apache']['listen'] = [83].concat(node['apache']['listen'])
end

include_recipe "jmh-webserver::default"

jmh_webserver 'failover' do
  name node['jmh_webserver']['failover']['apache_config']['server_name']
  apache_config node['jmh_webserver']['failover']['apache_config']
  doc_root node['jmh_webserver']['failover']['apache_config']['docroot']
  action :install
end

include_recipe "jmh-webserver::jmherror"

show_maintenance = node['jmh_webserver']['jmherror']['force_maintenance']

unless node['jmh_webserver']['jmherror']['force_maintenance']
  now = Time.now
  node['jmh_webserver']['jmherror']['maintenance_windows'].each do |window|
    startTime = Time.strptime(window[0],"%H:%M:%S")
    endTime = Time.strptime(window[1], "%H:%M:%S")
    Chef::Log.debug("Start #{startTime}   End #{endTime}   now #{now}")
    if now >= startTime && now < endTime
      show_maintenance = true
      break
    end
  end
end

template  File.join(node['jmh_webserver']['failover']['apache_config']['docroot'], "index.html") do
  source show_maintenance ? "jmherror/scheduled_maintenance.erb" : "jmherror/error.erb"
  mode 0644
  owner 'apache'
  group 'apache'
  variables(
    error_message: node['jmh_webserver']['jmherror']['error_message'],
    maintenance_header: node['jmh_webserver']['jmherror']['error_maintenance_header'],
    maintenance_message: node['jmh_webserver']['jmherror']['maintenance_message'],
  )
end