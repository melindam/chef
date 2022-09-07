name 'php_subsites'
description 'PHP Subsites'

run_list(
  "role[base]",
  "recipe[jmh-webserver::gituser]",
  "recipe[jmh-webserver::php_site]"
)

override_attributes(
  :apache => {
    :user => "gituser",
    :group => "gituser"
  },
  :jmh_webserver => {
    :php => {
      :subsites => {
        :apache_config => {
          :server_name => 'web01.johnmuirhealth.com',
          :server_aliases => ['web01'],
          :listen => true,
          :ip_address => '*',
          :custom_log => ['logs/custom-access_log combined'],
          :port => 82,
          :docroot => '/usr/local/webapps/subsites',
          :aliases => { "/heartistry" => "/usr/local/webapps/subsites/staticphp/heartistry",
                        "/consumer_personas" => "/usr/local/webapps/subsites/staticphp/consumer_personas",
                        "/history" => "/usr/local/webapps/subsites/staticphp/history",
                        "/mdstart" => "/usr/local/webapps/subsites/staticphp/mdstart"}
        },
        :git => {
          :custom => {
            :repository => "git@bitbucket.org:jmhebiz-ondemand/custom-php.git",
            :branch => "master"
          },
          :staticphp => {
            :repository => "git@bitbucket.org:jmhebiz-ondemand/static-php.git",
            :branch => "master"
          }
        }
      }
    }  
  }
)
