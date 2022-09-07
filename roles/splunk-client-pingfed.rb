name 'splunk-client-pingfed'

description 'Pingfed Log4J'

run_list(
  "role[base]",
  "recipe[jmh-splunk::client]"
)

override_attributes(
  :jmh_splunk => {
    :inputs_conf => {
        :inputs => [
            {
                :input_path => 'monitor:///usr/local/pingfederate/log/server.log',
                :config => {
                    :sourcetype => 'log4j'
                }
            }
        ]
      }
  }
)
