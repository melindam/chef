name 'splunk-client-myjmh-admin'

description 'myjmh-admin client config'

run_list(
    "role[base]",
    "recipe[jmh-splunk::client]"
)

override_attributes(
    :jmh_splunk => {
        :inputs_conf => {
            :inputs => [
               {
                :input_path => 'monitor:///usr/local/tomcat/myjmh-admin/logs/catalina.out',
                :config => {
                    :sourcetype => 'log4j'
                 }
               },
               {
                :input_path => 'monitor:///usr/local/tomcat/myjmh-admin/logs/myjmh_admin.log',
                :config => {
                    :sourcetype => 'log4j'
                 }
               }
          ]
      }
  }
)