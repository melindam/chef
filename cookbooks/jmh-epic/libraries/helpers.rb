# Used to get the java home for now
require 'chef/data_bag_item'
module JmhEpic
  class << self
    def get_epic_config(node)
      data_bag_item =  Chef::DataBagItem.load(node['jmh_epic']['data_bag'], node['jmh_epic']['environment'])
      return data_bag_item.to_hash
    end

    def get_interconnect_check_pages(node)
      interconnect_checks = Hash.new
      interconnect_checks['insecure'] = Hash.new
      interconnect_checks['secure'] = Hash.new
      interconnect_checks['mcm'] = Hash.new

      # get databags with env info and hostsfiles
      epic_bag = Chef::DataBag.load(node['jmh_epic']['data_bag'])
      epic_hostfile_bag = Chef::DataBagItem.load("hostsfile","epic_servers")
      epic_user_data_bag = Chef::EncryptedDataBagItem.load(node['jmh_epic']['data_bag'],'secure')

      # roll through all the databags looking
      epic_bag.each_key do |envname|
        unless envname == 'secure'
          envconfig = Chef::DataBagItem.load(node['jmh_epic']['data_bag'],envname)
          if envconfig['interconnect']['check_hosts']
            envconfig['interconnect']['check_hosts'].each do |name, hostname|
            interconnect_checks['insecure'][name] = { 'context': envconfig['interconnect']['context'],
                                          'clientid': envconfig['interconnect']['clientid'],
                                          'patient_mrn': envconfig['interconnect']['check_patient_mrn'],
                                           'hostname': hostname,
                                          'ipaddress': epic_hostfile_bag['hosts'][hostname]['ip']}
            interconnect_checks['secure'][name] = { 'context': envconfig['interconnect']['secure_context'],
                                                    'clientid': envconfig['interconnect']['clientid'],
                                                      'hostname': hostname,
                                                      'ipaddress': epic_hostfile_bag['hosts'][hostname]['ip']}
          end

          end
          if envconfig['mychart']['mcm_check_hosts']
            envconfig['mychart']['mcm_check_hosts'].each do |name, hostname|
              username=''
              password=''
              if epic_user_data_bag['myjmh'][envname]
                username= epic_user_data_bag['myjmh'][envname]['username']
                password= epic_user_data_bag['myjmh'][envname]['password']
              else
                username= epic_user_data_bag['myjmh']['default']['username']
                password= epic_user_data_bag['myjmh']['default']['password']
              end
              interconnect_checks['mcm'][name] = { 'context': envconfig['mychart']['mcm_context'],
                                                   'hostname': hostname,
                                                   'ipaddress': epic_hostfile_bag['hosts'][hostname]['ip'],
                                                    'username': username,
                                                    'password': password}
            end
          end
          # Chef::Log.warn("#{envname} #{envconfig['interconnect']['check_hosts'].to_s}")
        end
      end
      return interconnect_checks
    end

    def get_specific_epic_config(epic_env,node)
      data_bag_item =  Chef::DataBagItem.load(node['jmh_epic']['data_bag'], epic_env)
      return data_bag_item.to_hash
    end

    def get_interconnect_auth_client(auth_client,node)
      epic_user_data_bag =  Chef::EncryptedDataBagItem.load(node['jmh_epic']['data_bag'],'secure')
      if epic_user_data_bag['epic_accounts'][auth_client][node['jmh_epic']['environment']]
        return epic_user_data_bag['epic_accounts'][auth_client][node['jmh_epic']['environment']].to_hash
      else
        epic_user_data_bag['epic_accounts'][auth_client]['default'].to_hash
      end
    end

    def get_interconnect_auth_clients_java_properties(node)
      java_client_props = Array.new
      epic_user_data_bag = Chef::EncryptedDataBagItem.load(node['jmh_epic']['data_bag'],'secure')

      java_client_props.push("com.johnmuirhealth.epic.interconnect.auth.clients=#{epic_user_data_bag['epic_accounts'].keys.join(',')}")
      epic_user_data_bag['epic_accounts'].each_key do |user|
        creds = if epic_user_data_bag['epic_accounts'][user][node['jmh_epic']['environment']]
                  epic_user_data_bag['epic_accounts'][user][node['jmh_epic']['environment']]
                else
                  epic_user_data_bag['epic_accounts'][user]['default']
                end
        java_client_props.push("com.johnmuirhealth.epic.interconnect.auth.#{user}.username=#{creds['username']}")
        java_client_props.push("com.johnmuirhealth.epic.interconnect.auth.#{user}.password=#{creds['password']}")
      end
      return java_client_props

    end

    def get_environment_java_properties(node)
      environment_config = Chef::DataBagItem.load(node['jmh_epic']['data_bag'], node['jmh_epic']['environment'])
      epic_user_data_bag = Chef::EncryptedDataBagItem.load(node['jmh_epic']['data_bag'],'secure')
      # Chef::Log.warn(environment_config.to_s)
      java_props = Array.new

      # Add all the epic properties
      java_props_before = node['jmh_epic']['java_properties_raw'] + node['jmh_epic']['additional_java_properties']
      # If there are extra properties needed for the Epic Environment, add them.
      java_props_before.concat( environment_config['java_properties'] ) if environment_config['java_properties']
      # Add global webserver variables into the mix
      node['jmh_server']['global']['apache'].each_key do | webserver |
        Chef::Log.info("Global Webserver is #{webserver}")
          environment_config[webserver] = node['jmh_server']['global']['apache'][webserver]
      end

      java_props_before.each do | jprop|
        jprop_after = String.new(jprop)
        environment_config.each_key do |app|
          next if %w(id java_properties).include?(app)
          Chef::Log.debug("** #{environment_config[app].to_s}")
          environment_config[app].each_key do |app_value|
            new_value = environment_config[app][app_value].to_s
            env_field = "#{app.upcase}.#{app_value.upcase}"
            Chef::Log.debug ("*** #{env_field} = #{new_value} / #{jprop_after}")
            jprop_after = jprop_after.gsub(/\${#{env_field}}/  , new_value)
          end
        end
        epic_user_data_bag['epic_accounts'].each_key do |user|
          creds = if epic_user_data_bag['epic_accounts'][user][node['jmh_epic']['environment']]
                    epic_user_data_bag['epic_accounts'][user][node['jmh_epic']['environment']]
                  else
                    epic_user_data_bag['epic_accounts'][user]['default']
                  end
          creds.each_key do |credfield|
            Chef::Log.debug("#{user.upcase}.#{credfield.upcase} #{creds[credfield]}")
            jprop_after = jprop_after.gsub(/\${#{user.upcase}.#{credfield.upcase}}/  , creds[credfield])
          end
        end
        java_props.push(jprop_after)
      end
      return java_props

    end
  end

end

