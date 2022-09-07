name 'splunk-client-scheduling'

description 'Forwards logs for /scheduling API'

run_list(
  "role[base]",
  "recipe[jmh-splunk::client]"
)

override_attributes(
  :jmh_splunk => {
    :inputs_conf => {
      :inputs => [
          {
            :input_path => 'monitor:///usr/local/tomcat/scheduling/logs/catalina.out',
            :config => {
                :sourcetype => 'log4j'
            }
          },
         {
            :input_path => 'monitor:///usr/local/tomcat/scheduling/logs/scheduling-services.log',
            :config => {
                :sourcetype => 'log4j'
            }
          },
         {
            :input_path => 'monitor:///usr/local/tomcat/scheduling/logs/cache.log',
            :config => {
                :sourcetype => 'log4j'
            }
          },
          {
            :input_path => 'monitor:///usr/local/tomcat/scheduling/logs/captcha.log',
            :config => {
                :sourcetype => 'log4j'
            }
          }
      ]
    }
  }
)
