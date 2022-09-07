name 'splunk-client-vvisits'

description 'Forwards logs for vvisits_api recipe'

run_list(
  "role[base]",
  "recipe[jmh-splunk::client]"
)

override_attributes(
    :jmh_splunk => {
        :inputs_conf => {
            :inputs => [
                {
                  :input_path => 'monitor:///usr/local/nodeapp/vvisits-logs/vvisits.log',
                  :config => {
                      :sourcetype => 'node-vvisits'
                  }
                },
                {
                    :input_path => 'monitor:///usr/local/nodeapp/vvisits-logs/collect-api.log',
                    :config => {
                        :sourcetype => 'node-vvisits'
                    }
                },
                {
                    :input_path => 'monitor:///usr/local/nodeapp/vvisits-logs/audit-videovisit.log',
                    :config => {
                        :sourcetype => 'node-vvisits'
                    }
                },
                {
                    :input_path => 'monitor:///usr/local/nodeapp/vvisits-logs/hipaa-audit.log',
                    :config => {
                        :sourcetype => 'node-vvisits'
                    }
                }
            ]
        }
    }
)
