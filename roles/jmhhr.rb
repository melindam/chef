name 'jmhhr'

description 'Provides HR site'

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
      :hr80 => {
        :apache_config => {
          :server_name => 'www.johnmuirhr.com',
          :server_aliases => ['www02.johnmuirhr.com',"localhost"],
          :docroot => '/usr/local/webapps/subsites/hr',
          :custom_log => ['logs/hr-access_log combined'],
          :rewrite_log => 'logs/hr-rewite_log',
          :rewrite_level => 0,
          :cond_rewrites => { '^/(.*) https://%{HTTP_HOST}%{REQUEST_URI} [NC,L]' =>
                              ['%{HTTP:X-Forwarded-Proto} =http [OR]',
                              '%{HTTPS} off']
                            },
          :ip_address => '*',
          :server_status => true,
          :port => 80
        },
        :git => {
            :hr => {
              :repository => 'git@bitbucket.org:jmhebiz-ondemand/web-hr.git',
              :branch => "master"
            }
        } 
      }, 
      :hr => {
        :apache_config => {
          :server_name => 'www.johnmuirhr.com',
          :server_aliases => ['www02.johnmuirhr.com'],
          :docroot => '/usr/local/webapps/subsites/hr',
          :ip_address => '*',
          :directory_index => 'index.php',
          :port => 443,
          :custom_log => ['logs/hr-access_log combined'],
          :robots_disallow => ['/'],
          :server_status => true,
          :ssl => {
               :data_bag => 'apache_ssl',
               :data_bag_item =>  'www_johnmuirhr_com_cert', 
               :encrypted => true
            }, 
            :ssl_pem_file => '/etc/httpd/ssl/www_johnmuirhr_com_cert.pem',
            :ssl_key_file => '/etc/httpd/ssl/www_johnmuirhr_com_cert.key',
            :ssl_chain_file => '/etc/httpd/ssl/www_johnmuirhr_com_cert.chain'
        }
      }
    }  
  }
)
