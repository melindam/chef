name 'splunk-client-apps07'

description 'Forwards logs for apps07'

run_list(
  "role[base]",
  "recipe[jmh-splunk::client]"
)

override_attributes(
    :jmh_splunk => {
        :inputs_conf => {
            :inputs => [
                {
                  :input_path => 'monitor:///usr/local/tomcat/profile-client/logs/catalina.out',
                  :config => {
                      :sourcetype => 'log4j'
                  }
                },
                {
                  :input_path => 'monitor:///usr/local/tomcat/profile-client/logs/profile.log',
                  :config => {
                      :sourcetype => 'log4j'
                  }
                },
                {
                  :input_path => 'monitor:///usr/local/nodeapp/profile-api-logs/patient-api.log',
                  :config => {
                      :sourcetype => 'node-profile-api'
                  }
                },
                {
                  :input_path => 'monitor:///usr/local/nodeapp/profile-api-logs/profile-api.log',
                  :config => {
                      :sourcetype => 'node-profile-api'
                  }
                },
                {
                  :input_path => 'monitor:///usr/local/nodeapp/profile-api-logs/collect-api.log',
                  :config => {
                      :sourcetype => 'node-profile-api'
                  }
                },
                {
                    :input_path => 'monitor:///usr/local/nodeapp/profile-api-logs/collect-internal-api.log',
                    :config => {
                        :sourcetype => 'node-profile-api'
                    }
                },
                {
                    :input_path => 'monitor:///usr/local/nodeapp/profile-api-logs/internal-api.log',
                    :config => {
                        :sourcetype => 'node-profile-api'
                    }
                }
            ]
        }
    }
)
