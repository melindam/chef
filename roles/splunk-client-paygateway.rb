name 'splunk-client-paygateway'

description 'Forwards logs for paygateway cookbook'

run_list(
  "role[base]",
  "recipe[jmh-splunk::client]"
)

override_attributes(
    :jmh_splunk => {
        :inputs_conf => {
            :inputs => [
                {
                  :input_path => 'monitor:///usr/local/nodeapp/payment-gateway-logs/combined.log',
                  :config => {
                      :sourcetype => 'node-paygateway'
                  }
                },
                {
                    :input_path => 'monitor:///usr/local/nodeapp/payment-gateway-logs/error.log',
                    :config => {
                        :sourcetype => 'node-paygateway'
                    }
                }
            ]
        }
    }
)
