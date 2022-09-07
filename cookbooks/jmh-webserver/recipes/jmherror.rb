# Create JMH ERROR files
directory node['jmh_webserver']['jmherror']['dir'] do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
end

directory File.join(node['jmh_webserver']['jmherror']['dir'], 'img') do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
end

node['jmh_webserver']['jmherror']['files'].each do |error_file|
  cookbook_file File.join(node['jmh_webserver']['jmherror']['dir'], 'img', error_file) do
    source "img/#{error_file}"
    mode 0644
    owner 'apache'
    group 'apache'
  end
end

# Create Style Sheet CSS Files
directory File.join(node['jmh_webserver']['jmherror']['dir'], 'css') do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
end

node['jmh_webserver']['jmherror']['css'].each do |css_file|
  cookbook_file File.join(node['jmh_webserver']['jmherror']['dir'], 'css', css_file) do
    source "css/#{css_file}"
    mode 0644
    owner 'apache'
    group 'apache'
  end
end

# Create Fonts
directory File.join(node['jmh_webserver']['jmherror']['dir'], 'fonts') do
  owner 'apache'
  group 'apache'
  mode '0755'
  action :create
end

node['jmh_webserver']['jmherror']['fonts'].each do |font|
  cookbook_file File.join(node['jmh_webserver']['jmherror']['dir'], 'fonts', font) do
    source "fonts/#{font}"
    mode 0644
    owner 'apache'
    group 'apache'
  end
end

node['jmh_webserver']['jmherror']['template_files'].each do |error_page|
  template File.join(node['jmh_webserver']['jmherror']['dir'], "#{error_page}.html") do
    source "jmherror/#{error_page}.erb"
    mode 0644
    owner 'apache'
    group 'apache'
    variables(
      error_message: node['jmh_webserver']['jmherror']['error_message'],
      maintenance_message: node['jmh_webserver']['jmherror']['maintenance_message'],
      myjmh_maintenance_message: node['jmh_webserver']['jmherror']['myjmh_maintenance_message']
    )
  end
end

# Error/Maintenance Page

show_maintenance = node['jmh_webserver']['jmherror']['force_maintenance']

unless node['jmh_webserver']['jmherror']['force_maintenance']
  now = Time.now
  node['jmh_webserver']['jmherror']['maintenance_windows'].each do |window|
    startTime = Time.strptime(window[0], '%H:%M:%S')
    endTime = Time.strptime(window[1], '%H:%M:%S')
    Chef::Log.debug("Start #{startTime}   End #{endTime}   now #{now}")
    if now >= startTime && now < endTime
      show_maintenance = true
      break
    end
  end
end

template File.join(node['jmh_webserver']['jmherror']['dir'], 'error.html') do
  source show_maintenance ? 'jmherror/scheduled_maintenance.erb' : 'jmherror/error.erb'
  mode 0644
  owner 'apache'
  group 'apache'
  variables(
    error_message: node['jmh_webserver']['jmherror']['error_message'],
    maintenance_header: node['jmh_webserver']['jmherror']['error_maintenance_header'],
    maintenance_message: node['jmh_webserver']['jmherror']['maintenance_message']
  )
end

file File.join(node['jmh_webserver']['jmherror']['dir'], "oidcErrorTemplate.html") do
  action :delete
end