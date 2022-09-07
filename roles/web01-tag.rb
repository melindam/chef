name 'web01-tag'

description 'Creates tagging web server for web01 which runs Human Resources, MD, and Subsites web servers'

run_list(
  "role[base]",
  "recipe[jmh-webserver::gituser]",
  "recipe[jmh-webserver::php_site]",
  "recipe[jmh-webserver::php_site_tag]"

)

override_attributes(
  :apache => {
    :user => "gituser",
    :group => "gituser"
  },
  :jmh_webserver => {
    :php => {
      :sitetag => {
        :apache_config => {
          :server_name => 'ebiz15.hsys.local',
          :directory_index => 'index.php',
          :listen => true,
          :ip_address => '*',
          :port => 81,
          :docroot => '/usr/local/webapps/sitetag/html',
          :cgibin =>  '/usr/local/webapps/sitetag/cgi-bin',
          :directories => { "/usr/local/webapps/sitetag/cgi-bin/" => [ "Require all Granted"],
                            "/usr/local/webapps/sitetag/html" => ['Require all Granted'] },           
          :script_aliases => { "/cgi-bin" => "/usr/local/webapps/sitetag/cgi-bin/"}
        },
        :additional_modules => ['mod_cgi']  
      }   

    }  
  }
)