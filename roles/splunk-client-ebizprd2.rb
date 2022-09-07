name 'splunk-client-ebizprd2'

description 'Forwards logs for ebizprd2'

run_list(
  "role[base]",
  "recipe[jmh-splunk::client]"
)

override_attributes(
  :jmh_splunk => {
    :inputs_conf => {
      :inputs => [
          {
            :input_path => 'monitor:///usr/local/tomcat/mdsuspension/logs/catalina.out',
            :config => {
                :sourcetype => 'log4j'
            }
          }
      ]
    }
  }
)
