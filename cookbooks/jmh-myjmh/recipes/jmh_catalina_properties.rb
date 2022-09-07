# This file is used to generate the catalina.properties for Development Team
# pointing to the SBX environment for references to crowd, DB and JWT keys

catalina_props = []

directory File.join(node['jmh_webserver']['dev_tools_web_server']['apache_config80']['docroot'], 'catalina_properties') do
  owner node['apache']['user']
  group node['apache']['group']
  mode 0775
  action :create
end

aem_server = node['jmh_server']['global']['apache']['www']['server_name']

include_recipe 'jmh-epic::java_properties'
catalina_props.concat(node['jmh_epic']['java_properties'])
catalina_props.push("app.server=#{aem_server}/myjmh-client")
catalina_props.push("app.docs=https://#{aem_server}")
catalina_props.push("mobile.tnc.url=https://#{aem_server}/content/jmh/en/home/terms-of-use/myjmh-terms-of-use.html")

aem_css_server = node['jmh_myjmh']['aem_css_override'] ? node['jmh_myjmh']['aem_css_override'] : aem_server

# AEM Variables
catalina_props.push('# Global AEM Variables')
catalina_props.push(node['jmh_myjmh']['aem']['default_properties'])
catalina_props.push("cq.publish.host=https://#{aem_css_server}")
catalina_props.push("cq.css.host=https://#{aem_css_server}")
catalina_props.push('cq.omniture.env=jmhdev')

# # Vendor properties
zipnosis_secure_databag = Chef::EncryptedDataBagItem.load('broker', 'secure')
catalina_props.push('# Zipnosis')
catalina_props.push('com.johnmuirhealth.jwt.audience=zipnosis.com')
catalina_props.push("myjmh.zipnosis.jwt.key=#{zipnosis_secure_databag[node['jmh_myjmh']['zipnosis']['databag']['jwt_key_name']]}")
catalina_props.push("myjmh.private.key.path=~/keys/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
catalina_props.push("zipnosis.public.key.path=~/keys/#{node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name']}.der")
catalina_props.push("com.jmh.exam.zip.visits=#{node['jmh_myjmh']['zipnosis']['zip_visits']}")
catalina_props.push("com.jmh.exam.zip.base.url=#{node['jmh_myjmh']['zipnosis']['zip_url']}")
catalina_props.push('# JWT Vendor Properties')
catalina_props.push('com.johnmuirhealth.jwt.clients=zipnosis')
catalina_props.push("com.johnmuirhealth.jwt.zipnosis.tokenkey=#{zipnosis_secure_databag[node['jmh_myjmh']['zipnosis']['databag']['jwt_key_name']]}")
catalina_props.push("com.johnmuirhealth.jwt.jmh.privatekey.path=~/keys/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
catalina_props.push("com.johnmuirhealth.jwt.zipnosis.publickey.path=~/keys/#{node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name']}.der")
catalina_props.push('com.johnmuirhealth.jwt.zipnosis.audience=zipnosis.com')
catalina_props.push('com.johnmuirhealth.jwt.issuer=johnmuirhealth')

myjmh_server = 'localhost'
search(:node, 'recipes:jmh-myjmh\:\:client') do |n|
  if n.environment == node.environment
    if n['ipaddress'] == node['ipaddress']
      myjmh_server = '127.0.0.1'
    else
      myjmh_server = n['cloud']['public_hostname']
    end
    break
  else
    Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for myjmh server")
  end
end

# MyJMH & Profile Variables
catalina_props.push('# Profile Properties')
catalina_props.concat(node['jmh_myjmh']['profile']['default_properties'])
catalina_props.push("com.johnmuirhealth.myjmh.server=#{aem_server}")
catalina_props.push("myjmh.afterlogin.landing.page=https://#{aem_server}/myjmh-client/dashboard")
catalina_props.push("profile.security.client.cookie.domain=#{aem_server}")
catalina_props.push('# Myjmh Properties')
catalina_props.push('myjmh.services.app.name=myjmh')
catalina_props.push('myjmh.services.app.token=!@#myjmh!@#')

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
    Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for crowd server")
  end
end

crowd_databag = Chef::EncryptedDataBagItem.load(node['jmh_myjmh']['myjmh_crowd_databag'], node['jmh_myjmh']['myjmh_crowd_databag_item'])
crowd_application_password = if crowd_databag['crowd_password'][node['jmh_server']['environment']]
                               crowd_databag['crowd_password'][node['jmh_server']['environment']]
                             else
                               crowd_databag['crowd_password']['default']
                             end
crowd_hash = ['# Crowd Properties',
              "crowd.application.password=#{crowd_application_password}",
              "crowd.guest.user.password=#{crowd_application_password}",
              "application.password=#{crowd_application_password}"] +
    node['jmh_myjmh']['crowd']['default_properties']

catalina_props.concat(crowd_hash)
catalina_props.push("crowd.server=#{crowd_server}")
catalina_props.push("crowd.url=https://#{crowd_server}:8495/crowd/")
catalina_props.push("crowd.password.reset=https://#{crowd_server}:8495/crowd/console/forgottenlogindetails!default.action")
catalina_props.push("crowd.application.login.url=https://#{crowd_server}:8495/crowd")
catalina_props.push("application.login.url=https://#{crowd_server}:8495/crowd")
catalina_props.push("crowd.server.url=https://#{crowd_server}:8495/crowd/services/")
catalina_props.push("crowd.base.url=https://#{crowd_server}:8495/crowd")
catalina_props.push('crowd.guest.user.name=profilenonuser')
catalina_props.push('crowd.guest.user.password=42jh9Pezh2Mhw')
catalina_props.push('crowd.guest.user.group=PROFILE_NONUSER')

# DB connection
db_server = 'localhost'
search(:node, 'recipes:jmh-myjmh\:\:db') do |n|
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
catalina_props.push("hibernate.connection.username=profile_dev")
catalina_props.push("hibernate.connection.password=!@#profile!@#")
catalina_props.push("hibernate.connection.url=jdbc:mysql://#{db_server}/#{node['jmh_myjmh']['client']['db']['database']}")
catalina_props.push("jdbc.url=jdbc:mysql://#{db_server}/#{node['jmh_myjmh']['client']['db']['database']}")
catalina_props.push("jdbc.database.server=#{db_server}")
catalina_props.push("jdbc.password=profile_dev")
catalina_props.push("jdbc.username=!@#profile!@#")

template ::File.join(node['jmh_webserver']['dev_tools_web_server']['apache_config80']['docroot'], 'catalina_properties/myjmh_sbx_catalina.properties') do
  source 'jmh_catalina_properties.erb'
  cookbook 'jmh-tomcat'
  owner node['apache']['user']
  group node['apache']['group']
  mode 0644
  variables(
    :catalina_properties => catalina_props
  )
end
