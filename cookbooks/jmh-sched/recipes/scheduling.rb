
include_recipe 'jmh-utilities::hostsfile_epic_servers'

# https://jmhebiz.jira.com/wiki/spaces/CORE/pages/368574474/Open+Scheduling
epic_config = JmhEpic.get_epic_config(node)

interconnect_server_secured = "#{epic_config['interconnect']['protocol']}://#{epic_config['interconnect']['hostname']}/#{epic_config['interconnect']['secure_context']}"

mychart_server = "#{epic_config['mychart']['protocol']}://" +
    "#{epic_config['mychart']['hostname']}/#{epic_config['mychart']['sso_context']}"

cache_properties = ['# Cache Services Properties']
cache_properties.push("com.johnmuirhealth.epic.cache.url=#{mychart_server}")
cache_properties.push("com.johnmuirhealth.epic.schedulecaching.enable=#{node['jmh_sched']['cache']['enabled']}")
cache_properties.push("com.johnmuirhealth.epic.schedulecaching.refresh.interval.cron=#{node['jmh_sched']['cache']['refresh_cron']}")
cache_properties.push("com.johnmuirhealth.epic.schedulecaching.remote.timeout.seconds=#{node['jmh_sched']['cache']['timeout']}")
cache_properties.push("com.johnmuirhealth.epic.clientid=#{epic_config['interconnect']['clientid']}")

catalina_properties = ["osw.captcha.google.secret=#{node['jmh_sched']['google_secret']}",
                       "osw.captcha.google.score=#{node['jmh_sched']['google_captcha_score']}",
                        "osw.captcha.verification.endpoint=https://www.google.com/recaptcha/api/siteverify",
                        "com.johnmuirhealth.epic.secure.endpoint=#{interconnect_server_secured}",
                        "com.johnmuirhealth.epic.cache.url=#{mychart_server}",
                        "server.servlet.context-path=/scheduling"
                      ]
                      
profile_api_properties = ['# Profile API Properties']
profile_api_properties.push("profileapi.endpoints.updateMRN=https://#{node['jmh_server']['global']['apache']['api']['server_name']}/profile-api/patient/vaccination/updateMRN")
profile_api_properties.push("profileapi.endpoints.getMRNFromToken=https://#{node['jmh_server']['global']['apache']['api']['server_name']}/profile-api/patient/vaccination/getMRN")
profile_api_properties.push("vaccination.mrnupdate=true")

jmh_tomcat node['jmh_sched']['appserver']['name'] do
  java_version node['jmh_sched']['appserver']['java_version']
  port node['jmh_sched']['appserver']['port']
  shutdown_port node['jmh_sched']['appserver']['shutdown_port']
  jmx_port node['jmh_sched']['appserver']['jmx_port']
  ssl_port node['jmh_sched']['appserver']['ssl_port']
  iptables node['jmh_sched']['appserver']['iptables']
  newrelic node['jmh_sched']['appserver']['newrelic']
  max_heap_size node['jmh_sched']['appserver']['max_heap_size']
  version node['jmh_sched']['appserver']['version']
  catalina_properties catalina_properties + cache_properties + profile_api_properties + JmhEpic.get_interconnect_auth_clients_java_properties(node)
  rollout_array node['jmh_sched']['appserver']['rollout_array']
  action :create
end