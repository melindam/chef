# Include the apache_ports recipe so any required ports are properly open
include_recipe 'jmh-webserver::gituser'

# Jenky way to fix this, but HR will be going away.
if node['jmh_webserver']['php']['hr']
  node.default['jmh_webserver']['php']['hr']['apache_config']['rewrites'] =
      [ "/logout-instructions.php https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/logout-instructions.html [R,L]",
        "/workday-login-instructions-former-employee.php https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/workday-login-instructions-former-employee.html [R,L]",
        "/workday-login-instructions.php https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/workday-login-instructions.html [R,L]",
        "/workday-logout-instructions.php https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/logout-instructions.html [R,L]"]
  node.default['jmh_webserver']['php']['hr']['apache_config']['cond_rewrites'] =
      { ".* https://#{node['jmh_server']['global']['apache']['www']['server_name']}/custom/john-muir-hr.html [R=301,L]": ["%{HTTP_HOST} .*johnmuirhr.com"] }



  node.default['jmh_webserver']['php']['hr']['git'] = {'hr': {'repository': 'git@bitbucket.org:jmhebiz-ondemand/web-hr.git',
                                                              'branch':  "master"
                                                             }
  }
end

ports = []
%w(php).each do |key|
  next unless node['jmh_webserver'][key]
  node['jmh_webserver'][key].each do |_name, config|
    ports << config['apache_config']['port'] if config['apache_config']
  end
end
ports.map!(&:to_i)
if node['recipes'].include?('jmh-webserver::failover_site')
  ports.push(node['jmh_webserver']['failover']['apache_config']['port'])
end
if node['roles'].include?('jmhhr')
  ports.push(node['jmh_webserver']['php']['hr80']['apache_config']['port'])
  ports.push(node['jmh_webserver']['php']['hr']['apache_config']['port'])
end
ports.uniq!

node.default['jmh_webserver']['listen'] = ports unless ports.empty?

include_recipe 'jmh-webserver'
# Process all the applications defined in the php attribute
node['jmh_webserver']['php'].each_key do |attr_key|
  fail "Configuration for php subsite requested does not exist: #{attr_key}" unless node['jmh_webserver']['php'][attr_key]
  Chef::Log.debug("This is a PHP site I am working on #{node['jmh_webserver']['php'][attr_key]}")

  # This creates all the resources required for a standard JMH PHP
  # application. This is a definition, which is a collection of
  # reusable resources. It is defined within the definitions of this
  # cookbook.
  jmh_webserver_phpwebserver attr_key do
    git node['jmh_webserver']['php'][attr_key]['git']
    web_app node['jmh_webserver']['php'][attr_key]['apache_config']
    config node['jmh_webserver']['php'][attr_key]['config']
    additional_modules node['jmh_webserver']['php'][attr_key]['additional_modules']
    action :install
  end
end
