name 'splunk-client-fad'

description 'Forwards logs for fad'

run_list(
  "role[base]",
  "recipe[jmh-splunk::client]"
)

override_attributes(
  :jmh_splunk => {
    :inputs_conf => {
      :inputs => [
          {
          :input_path => 'monitor:///usr/local/tomcat/fad/logs/catalina.out',
          :config => {
              :sourcetype => 'log4j'
          }
        },
        {
          :input_path => 'monitor:///usr/local/tomcat/fad/logs/fad.log',
          :config => {
            :sourcetype => 'log4j'
          }
        }
      ]
    }
  }
)
