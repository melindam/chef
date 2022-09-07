catalina_props = []

directory File.join(node['jmh_webserver']['dev_tools_web_server']['apache_config80']['docroot'], 'catalina_properties') do
  owner node['apache']['user']
  group node['apache']['group']
  mode 0775
  action :create  
end

# Get the name of the author server for the environment
author_server = 'localhost'
search(:node, 'recipes:jmh-cq\:\:author') do |n|
  if n.environment == node.environment
    if n['ipaddress'] == node['ipaddress']
      author_server = '127.0.0.1'
    else
      author_server = n['cloud']['public_hostname']
    end
    break
  else
    Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for author server")
  end
end

# Author AEM properties
catalina_props.push('# AEM Variables')
catalina_props.push("cq.author.host=http://#{author_server}:4502")
catalina_props.push("cq.author.user=eventmanageruser")
catalina_props.push("cq.author.pass=eventmanageruser")
catalina_props.push("cq.author.event.endPoint.url=http://#{author_server}:4502/content/jmh/en/home.manageEvent.html")

aem_server = 'localhost'
if node['cq'] && node['cq']['dispatcher'] && node['cq']['dispatcher']['www']
  aem_server = node['cq']['dispatcher']['www']['server_name']
end


# Crowd
crowd_server = 'localhost'
search(:node, 'recipes:jmh-crowd\:\:default') do |n|
  if n.environment == node.environment
    if n['ipaddress'] == node['ipaddress']
      crowd_server = '127.0.0.1'
    else
      crowd_server = n['cloud']['public_hostname']
    end
    break
  else
    Chef::Log.debug("Skipping #{n.name} #{n['ipaddress']} for crowd server")
  end
end

catalina_props.push("crowd.url=#{crowd_server}")
catalina_props.push("application.name                        eventmanager")
catalina_props.push("application.password                    Jmmdh5")
catalina_props.push("application.login.url                   https://#{crowd_server}:8495/crowd/")
catalina_props.push("crowd.server.url                        https://#{crowd_server}:8495/crowd/services/")
catalina_props.push("session.isauthenticated                 session.isauthenticated")
catalina_props.push("session.tokenkey                        session.tokenkey")
catalina_props.push("session.validationinterval              0")
catalina_props.push("session.lastvalidation                  session.lastvalidation")


# DB connection
db_server = 'localhost'
search(:node, 'recipes:jmh-events\:\:db') do |n|
  if n.environment == node.environment
    if n['ipaddress'] == node['ipaddress']
      db_server = '127.0.0.1'
    else
      db_server = n['cloud']['public_hostname']
    end
    break
  else
    Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for db server")
  end
end

catalina_props.push('# DB Connections')
catalina_props.push("hibernate.connection.username=events")
catalina_props.push("hibernate.connection.password=!@#events!@#")
catalina_props.push("hibernate.connection.url=jdbc:mysql://#{db_server}/#{node['jmh_events']['client']['db']['database']}")
catalina_props.push("jdbc.driverClassName=com.mysql.jdbc.Driver")
catalina_props.push("jdbc.url=jdbc:mysql://#{db_server}/#{node['jmh_events']['client']['db']['database']}")
catalina_props.push("jdbc.database.server=#{db_server}")
catalina_props.push("jdbc.password=!@#events!@#")

# TODO: create this for tomcat instances
# create developers SBX catalina.properties file
template ::File.join(node['jmh_webserver']['dev_tools_web_server']['apache_config80']['docroot'], 'catalina_properties/events_sbx_catalina.properties') do
  source 'jmh_catalina_properties.erb'
  cookbook 'jmh-tomcat'
  owner node['apache']['user']
  group node['apache']['group']  
  mode 0644
  variables(
    :catalina_properties => catalina_props 
  )
end
