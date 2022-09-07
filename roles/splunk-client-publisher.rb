name 'splunk-client-publisher'

description 'Forwards logs for publisher 6.4'

run_list(
  "role[base]",
  "recipe[jmh-splunk::client]"
)

override_attributes(
  :jmh_splunk => {
    :inputs_conf => {
      :inputs => [
        {
          :input_path => 'monitor:///usr/local/cq/publish01-65/crx-quickstart/logs/error.log',
          :config => {
              :sourcetype => 'log4j'
          }
        }
      ]
    }
  }
)
