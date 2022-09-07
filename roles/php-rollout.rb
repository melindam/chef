name 'php-rollout'

description 'Builds JMH Server web01 which runs Human Resources, MD, and Subsites web servers'

run_list(
  "role[base]",
  "recipe[jmh-webserver::gituser]",
  "recipe[jmh-webserver::php_site]",
  "recipe[jmh-webserver::php_site_rollout]"

)

override_attributes(
  :apache => {
    :user => "gituser",
    :group => "gituser"
  },
  :jmh_webserver => {
    :php => {
      :siterollout => {
        :apache_config => {
          :server_name => 'web01.johnmuirhealth.com',
          :directory_index => 'index.php',
          :listen => true,
          :ip_address => '*',
          :port => 81,
          :docroot => '/usr/local/webapps/siterollout/html',
          :cgibin => '/usr/local/webapps/siterollout/cgi-bin',
          :directories => { "/usr/local/webapps/siterollout/cgi-bin/" => [ "Allow from all"] ,
                           "/usr/local/webapps/siterollout/html" => ['Options -Indexes','AllowOverride All','Allow from All'] },
          :directories_apache24 => { "/usr/local/webapps/siterollout/cgi-bin/" => [ "Require all Granted"] ,
                                     "/usr/local/webapps/siterollout/html" => ['Options -Indexes','Require all Granted'] },
          :script_aliases => { "/cgi-bin" => "/usr/local/webapps/siterollout/cgi-bin/"}
        },
        :additional_modules => ['mod_cgi']    
      }
    }  
  }
)