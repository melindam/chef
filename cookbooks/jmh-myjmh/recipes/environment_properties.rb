global_props = []


include_recipe 'jmh-myjmh::definitions'

# Get the name of the front end for the environment
aem_server = node['jmh_server']['global']['apache']['www']['server_name']

# Set Epic global variables
include_recipe 'jmh-epic::java_properties'
global_props.concat(node['jmh_epic']['java_properties'])

global_props.push("app.server=#{aem_server}/myjmh-client")
global_props.push("app.docs=https://#{aem_server}")
global_props.push("mobile.tnc.url=https://#{aem_server}/content/jmh/en/home/terms-of-use/myjmh-terms-of-use.html")

# TODO enable or disable flag for when moving to AEM
# roll back value below for cq.publish.host and cq.css.host to be aem_server
aem_css_server = node['jmh_myjmh']['aem_css_override'] ? node['jmh_myjmh']['aem_css_override'] : aem_server

# AEM Variables
global_props.push('# Global AEM Variables')
global_props.concat(node['jmh_myjmh']['aem']['default_properties'])
global_props.push("cq.publish.host=https://#{aem_css_server}")
global_props.push("cq.css.host=https://#{aem_css_server}")
if node['jmh_server']['environment'] == 'prod'
  global_props.push('cq.omniture.env=jmhprod')
else
  global_props.push('cq.omniture.env=jmhdev')
end

include_recipe 'jmh-myjmh::zipnosis_keys'

zipnosis_secure_databag = Chef::EncryptedDataBagItem.load('broker', 'secure')
global_props.push('# Zipnosis ')
global_props.push('com.johnmuirhealth.jwt.audience=zipnosis.com')
global_props.push("myjmh.zipnosis.jwt.key=#{zipnosis_secure_databag[node['jmh_myjmh']['zipnosis']['databag']['jwt_key_name']]}")
global_props.push("myjmh.private.key.path=#{node['jmh_myjmh']['zipnosis']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
global_props.push("zipnosis.public.key.path=#{node['jmh_myjmh']['zipnosis']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name']}.der")
global_props.push("com.jmh.exam.zip.visits=#{node['jmh_myjmh']['zipnosis']['zip_visits']}")
global_props.push("com.jmh.exam.zip.base.url=#{node['jmh_myjmh']['zipnosis']['zip_url']}")
global_props.push('# JWT Vendor Properties')
global_props.push('com.johnmuirhealth.jwt.clients=zipnosis')
global_props.push("com.johnmuirhealth.jwt.zipnosis.tokenkey=#{zipnosis_secure_databag[node['jmh_myjmh']['zipnosis']['databag']['jwt_key_name']]}")
global_props.push("com.johnmuirhealth.jwt.jmh.privatekey.path=#{node['jmh_myjmh']['zipnosis']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['private_ssh_key']['name']}.der")
global_props.push("com.johnmuirhealth.jwt.zipnosis.publickey.path=#{node['jmh_myjmh']['zipnosis']['key_dir']}/#{node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name']}.der")
global_props.push('com.johnmuirhealth.jwt.zipnosis.audience=zipnosis.com')
global_props.push('com.johnmuirhealth.jwt.issuer=johnmuirhealth')

# Profile Variables
global_props.push('# Profile Properties')
global_props.concat(node['jmh_myjmh']['profile']['default_properties'])
global_props.push("com.johnmuirhealth.myjmh.server=#{aem_server}")
global_props.push("myjmh.afterlogin.landing.page=https://#{aem_server}/myjmh-client/dashboard")
global_props.push("profile.security.client.cookie.domain=#{aem_server}")

# MyJMH Variables
myjmh_server = 'localhost'
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, 'recipes:jmh-myjmh\:\:client') do |n|
    if n.environment == node.environment
      if n['ipaddress'] == node['ipaddress']
        myjmh_server = '127.0.0.1'
      else
        myjmh_server = n['ipaddress']
      end
      break
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for profile server")
    end
  end
end
global_props.push('# Myjmh Properties')
global_props.push('myjmh.services.app.name=myjmh')
global_props.push('myjmh.services.app.token=!@#myjmh!@#')



crowd_hash = ['# Crowd Properties',
              "crowd.application.password=#{node['jmh_myjmh']['crowd_application_password']}",
              "crowd.guest.user.password=#{node['jmh_myjmh']['crowd_application_password']}",
              "application.password=#{node['jmh_myjmh']['crowd_application_password']}"] +
              node['jmh_myjmh']['crowd']['default_properties']

# Crowd
global_props.concat(crowd_hash)
global_props.push("crowd.server=crowd.jmh.internal")
global_props.push("crowd.url=https://crowd.jmh.internal:8495/crowd/")
global_props.push("crowd.password.reset=https://crowd.jmh.internal:8495/crowd/console/forgottenlogindetails!default.action")
global_props.push("crowd.application.login.url=https://crowd.jmh.internal:8495/crowd")
global_props.push("application.login.url=https://crowd.jmh.internal:8495/crowd")
global_props.push("crowd.server.url=https://crowd.jmh.internal:8495/crowd/services/")
global_props.push("crowd.base.url=https://crowd.jmh.internal:8495/crowd")
global_props.push('crowd.guest.user.name=profilenonuser')
global_props.push('crowd.guest.user.password=42jh9Pezh2Mhw')
global_props.push('crowd.guest.user.group=PROFILE_NONUSER')

node.default['jmh_myjmh']['global_properties'] = global_props

# hostfiles updates
include_recipe 'jmh-utilities::hostsfile_internal'
include_recipe 'jmh-utilities::hostsfile_epic_servers'
include_recipe 'jmh-utilities::hostsfile_www_servers'
include_recipe 'jmh-utilities::hostsfile_profile_servers'
include_recipe 'jmh-utilities::hostsfile_crowd_servers'
