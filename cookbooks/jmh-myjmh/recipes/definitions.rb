# DB
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, 'recipes:jmh-myjmh\:\:db') do |n|
    if n.environment == node.environment
      if n['ipaddress'] == node['ipaddress']
        node.default['jmh_myjmh']['db']['server'] = '127.0.0.1'
      else
        node.default['jmh_myjmh']['db']['server'] = n['ipaddress']
      end
      break
    else
      Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']} for db server")
    end
  end
end

# Crowd
crowd_databag = Chef::EncryptedDataBagItem.load(node['jmh_myjmh']['myjmh_crowd_databag'], node['jmh_myjmh']['myjmh_crowd_databag_item'])
node.default['jmh_myjmh']['crowd_application_password'] = if crowd_databag['crowd_password'][node['jmh_server']['environment']]
                                                             crowd_databag['crowd_password'][node['jmh_server']['environment']]
                                                           else
                                                             crowd_databag['crowd_password']['default']
                                                          end
node.default['jmh_myjmh']['crowd_java_properties'] = ['# Crowd Properties',
                                                "crowd.application.password=#{node['jmh_myjmh']['crowd_application_password']}",
                                                "crowd.guest.user.password=#{node['jmh_myjmh']['crowd_application_password']}",
                                                "application.password=#{node['jmh_myjmh']['crowd_application_password']}",
                                                "crowd.server=crowd.jmh.internal",
                                                "crowd.url=https://crowd.jmh.internal:8495/crowd/",
                                                "application.login.url=https://crowd.jmh.internal:8495/crowd",
                                                "crowd.application.login.url=https://crowd.jmh.internal:8495/crowd",
                                                "crowd.server.url=https://crowd.jmh.internal:8495/crowd/services/",
                                                "crowd.base.url=https://crowd.jmh.internal:8495/crowd"] +
                                                node['jmh_myjmh']['crowd']['default_properties']
