default['cq']['dispatcher']['apache_mod_s3_key'] = 'dispatcher/dispatcher-apache2.4-4.2.3.so'

default['cq']['dispatcher']['publisher_role'] = 'cq-publisher'
default['cq']['dispatcher']['author_role'] = 'cq-author'
default['cq']['dispatcher']['enable_remoteip'] = true

default['cq']['dispatcher']['www']['server_name'] = node['jmh_server']['global']['apache']['www']['server_name']
default['cq']['dispatcher']['www']['server_aliases'] = node['jmh_server']['global']['apache']['www']['server_aliases']

default['cq']['dispatcher']['domain_maps']['base_domain'] = 'johnmuirhealth.com'
default['cq']['dispatcher']['modules'] = %w(deflate expires)
default['cq']['dispatcher']['www_configs']['rewrites'] = ["^/robots.txt$ - [L]",
                                                          "^/fsgbb241.txt$ - [L]",
                                                          "^/jmherror/(.*) /jmherror/$1 [PT,L]",
                                                          "^/content/jmh/(.*) /content/jmh/$1 [PT,L]",
                                                          "^/content/forms/(.*) /content/forms/$1 [PT,L]",
                                                          "^/content/campaigns/(.*) /content/campaigns/$1 [PT,L]",
                                                          "^/conf/jmh/settings/(.*) /conf/jmh/settings/$1 [PT,L]",
                                                          "^/content/dam/jmh/(.*) /content/dam/jmh/$1 [PT,L]",
                                                          "^/videovisit(.*) /vv/visit/visit.html$1 [L]",
                                                          "^/doctor/(.+)/(.+)$ /content/jmh/en/home/doctor?npi=$2 [QSA,P]"]
default['cq']['dispatcher']['www_configs']['ssl_rewrites'] = [ "^/*$ /content/jmh/en/home.html [PT,L]"]
default['cq']['dispatcher']['www_configs']['cq_ignore_content_http'] = [ "%{IS_SUBREQ} false",
                                                                        "%{REQUEST_URI} !/dispatcher/invalidate.cache$",
                                                                        "%{REQUEST_URI} !/content/etc/.*$",
                                                                        "%{REQUEST_URI} !/server-status.*$",
                                                                        "%{REQUEST_URI} !/etc/.*$",
                                                                        "%{REQUEST_URI} !/etc.clientlibs/.*$",
                                                                        "%{REQUEST_URI} !/libs/.*$",
                                                                        "%{REQUEST_URI} !/tmp/.*$",
                                                                        "%{REQUEST_URI} !/bin/.*$",
                                                                        "%{REQUEST_URI} !^/content/dam/.*$",
                                                                        "%{REQUEST_URI} !^/home/users/.*$",
                                                                        "%{REQUEST_URI} !^/content/campaigns/.*$"]
default['cq']['dispatcher']['www_configs']['cq_ignore_content_https'] = ["%{IS_SUBREQ} false",
                                                                        "%{REQUEST_URI} !/content/etc/.*$",
                                                                        "%{REQUEST_URI} !/server-status.*$",
                                                                        "%{REQUEST_URI} !^/customphonebook.*xml$",
                                                                        "%{REQUEST_URI} !/etc/.*$",
                                                                        "%{REQUEST_URI} !/etc.clientlibs/.*$",
                                                                        "%{REQUEST_URI} !/libs/.*$",
                                                                        "%{REQUEST_URI} !/bin/.*$",
                                                                        "%{REQUEST_URI} !/tmp/.*$",
                                                                        "%{REQUEST_URI} !^/app_widgets.*$",
                                                                        "%{REQUEST_URI} !^/webcommon.*$",
                                                                        "%{REQUEST_URI} !^/vv/.*$",
                                                                        "%{REQUEST_URI} !^/content/dam/.*$",
                                                                        "%{REQUEST_URI} !^/home/users/.*$",
                                                                        "%{REQUEST_URI} !^/content/campaigns/.*$"]

default['cq']['dispatcher']['www']['content_home'] = '/content/jmh/en/home'

# defaults to delete, but environment updates it
default['cq']['dispatcher']['install_customphonebook'] = false

default['cq']['dispatcher']['app_proxies'] = %w( domain_redirects site_redirects page_redirects jmherror )

default['cq']['dispatcher']['jmherror']['dir'] = File.join(node['cq']['dispatcher']['document_root'], 'jmherror')
default['cq']['dispatcher']['jmherror']['files'] = %w(baby.jpg fixIE6.css fixIE7.css logo.gif maintenance_boxes.jpg medallion.png
                                                      static.css supersleight.plugin)
default['cq']['dispatcher']['jmherror']['template_files'] = %w(error maintenance myjmh_maintenance pagenotfound)
default['cq']['dispatcher']['jmherror']['error_message'] = "<p class=\"intro-text\">John Muir Health is experiencing some technical difficulties." \
                                                           '<br/>Please try clicking refresh.' \
                                                           "<br/>If not, we will be back online soon.<p class=\"intro-text\">"
default['cq']['dispatcher']['default_proxy_maintenance_page'] = '/jmherror/maintenance.html'
default['cq']['dispatcher']['jmherror']['maintenance_message'] = "<p class=\"intro-text\">
 MyChart is temporarily unavailable<br>due to scheduled system maintenance.
 <br><br>Thank you for your patience. </p>
<p class=\"intro-text\">
While you wait, feel free to <a href=\"mailto:info@johnmuirhealth.com\">email us</a>.  </p>"
default['cq']['dispatcher']['jmherror']['myjmh_maintenance_message'] = "<h3 class=\"brighttext\">MyChart will be back online soon.</h3>"

default['cq']['dispatcher']['ssl_redirect_rewrite'] =  ['%{HTTP:X-Forwarded-Proto} =http [OR]',
                                                        '%{HTTPS} off',
                                                        '%{REQUEST_URI} !/dispatcher/invalidate.cache$']
default['cq']['dispatcher']['robots']['file'] = 'robots.txt'
default['cq']['dispatcher']['robots']['site_maps'] = %w(/fad/sitemap /content/dam/jmh/Documents/JMHSitemap.xml)
default['cq']['dispatcher']['robots']['disallow'] = ['/custom/', '/mdstart', ' /*/tests/*']
default['cq']['dispatcher']['ssl']['enabled'] = true
default['cq']['dispatcher']['ssl']['data_bag'] = 'apache_ssl'
default['cq']['dispatcher']['ssl']['cert_hash'] = { 'www' => 'johnmuirhealth_com_cert',
                                                    'prc' => 'johnmuirhealth_com_cert' }

default['cq']['dispatcher']['max_header_size'] = node['jmh_server']['global']['max_header_size'] ? node['jmh_server']['global']['max_header_size'] : '8192'
default['cq']['dispatcher']['common_http']['cookbook'] = 'jmh-webserver'
default['cq']['dispatcher']['common_http']['docroot'] = node['cq']['dispatcher']['document_root']
default['cq']['dispatcher']['common_http']['server_name'] = node['cq']['dispatcher']['www']['server_name']
default['cq']['dispatcher']['common_http']['server_aliases'] = node['cq']['dispatcher']['www']['server_aliases']
default['cq']['dispatcher']['common_http']['rewrite_log_level'] = 1
default['cq']['dispatcher']['common_http']['proxy_requests'] = false
default['cq']['dispatcher']['common_http']['proxy_preserve_host'] = true
default['cq']['dispatcher']['common_http']['ssl_proxy_engine'] = 'on'
default['cq']['dispatcher']['common_http']['ip_address'] = '*'
default['cq']['dispatcher']['common_http']['server_status'] = true

default['cq']['dispatcher']['http']['port'] = 80
default['cq']['dispatcher']['http']['error_log'] = 'logs/www-error.log'
default['cq']['dispatcher']['http']['custom_log'] = 'logs/www-access.log combinedproxy'
default['cq']['dispatcher']['http']['rewrite_log'] =  'logs/www-rewrite.log'
default['cq']['dispatcher']['http']['rewrites'] = node['cq']['dispatcher']['www_configs']['rewrites']

default['cq']['dispatcher']['https']['port'] = 443
default['cq']['dispatcher']['https']['error_log'] = 'logs/www-error-ssl.log'
default['cq']['dispatcher']['https']['custom_log'] = 'logs/www-access-ssl.log combinedproxy'
default['cq']['dispatcher']['https']['rewrite_log'] = 'logs/www-rewrite-ssl.log'
default['cq']['dispatcher']['https']['ssl']['encrypted'] = true
default['cq']['dispatcher']['https']['ssl']['data_bag'] = node['cq']['dispatcher']['ssl']['data_bag']
default['cq']['dispatcher']['https']['ssl']['data_bag_item'] = 'johnmuirhealth_com_cert'
default['cq']['dispatcher']['https']['rewrites'] =  node['cq']['dispatcher']['www_configs']['rewrites'] + node['cq']['dispatcher']['www_configs']['ssl_rewrites']
default['cq']['dispatcher']['https']['limit_request'] = ("LimitRequestFieldSize #{node['cq']['dispatcher']['max_header_size']}")
default['cq']['dispatcher']['https']['header_access_control'] = true
default['cq']['dispatcher']['https']['prerender_io'] = true
default['cq']['dispatcher']['https']['root_location'] =  ['Require all granted']
default['cq']['dispatcher']['https']['locations'] =  {}
default['cq']['dispatcher']['https']['directories'] = {
    node['cq']['dispatcher']['document_root'] => {
        'Options' => '-Indexes',
        'AllowOverride' => 'None',
        'Require' => 'all Granted' },
    '/var/www/html/vv' => {
        'RewriteCond %{REQUEST_FILENAME} -f' => '[OR]',
        'RewriteCond %{REQUEST_FILENAME}' => '-d',
        'RewriteRule ^ -' =>  '[L]',
        'RewriteRule' => '^ index.html [L]'} }

# Defined within the dispatcher.rb recipe
# Keep because we have to have one "additional_cond_rewrites" to make recipe work
# remove the ^/vv/createvisit.* if we want to expose to internet
default['cq']['dispatcher']['additional_cond_rewrites'] = {"^(.*)$ /jmherror/pagenotfound.html [PT,L]":
              [ "%{HTTP_HOST} !(#{node['jmh_server']['global']['apache']['supportportal']['server_name']})",
                "%{REQUEST_URI}   ^/app_widgets/scheduling/video/createAppt.* [OR]",
                "%{REQUEST_URI}   ^/vv/createvisit.*" ]  }
default['cq']['dispatcher']['https']['redirect_matches'] = node['cq']['dispatcher']['www_configs']['redirect_match_https']
default['cq']['dispatcher']['https']['header_ie11'] = true

default['cq']['dispatcher']['config']['dispatcher_config'] = 'conf/dispatcher.any'
default['cq']['dispatcher']['config']['dispatcher_log'] = 'logs/dispatcher.log'
default['cq']['dispatcher']['config']['dispatcher_log_level'] = 1
default['cq']['dispatcher']['config']['dispatcher_decline_root'] = 'Off'
default['cq']['dispatcher']['config']['dispatcher_use_processed_url'] = 'On'

# Dispatcher evaluates filters from bottom up.  Put allow at bottom, deny at top
default['cq']['dispatcher']['any'] = {
  :name => 'internet-server',
  :farms => {
    :website => {
      :clientheaders => ['*'],
      :virtualhosts => ['*'],
      :renders => {
      },
      :filter => {
        '0001' => { 'glob' => "*", 'type' => "deny" },
        '0002' => { 'glob' => "* /content/*", 'type' => "allow" },
        '0003' => { 'glob' => "* /etc/*", 'type' => "allow" },
        '0004' => { 'glob' => "* /libs*", 'type' => "deny" },
        '0005' => { 'glob' => "* /system/sling/logout*", 'type' => "allow" },
        '0006' => { 'glob' => "* /apps/foundation/components/download/resources[./]*", 'type' => "allow" },
        '0007' => { 'glob' => "* /etc/linkchecker.html*", 'type' => "deny" },
        '0008' => { 'glob' => "* /etc/reports*", 'type' => "deny" },
        '0009' => { 'glob' => "GET *internalAddress.json*", 'type' => "allow" },
        '0020' => { 'glob' => "* *.pages.json*", 'type' => "deny" },
        '0021' => { 'glob' => "* *.languages.json*", 'type' => "deny" },
        '0022' => { 'glob' => "* *.blueprint.json*", 'type' => "deny" },
        '0023' => { 'glob' => "* *content.json*", 'type' => "deny" },
        '0024' => { 'glob' => "GET *.infinity.json*", 'type' => "deny" },
        '0025' => { 'glob' => "GET *.tidy.json*", 'type' => "deny" },
        '0026' => { 'glob' => "GET *.*[0-9].json*", 'type' => "deny" },
        '0027' => { 'glob' => "* *.query.json*", 'type' => "deny" },
        '0050' => { 'glob' => "* *.feed*", 'type' => "deny" },
        '0051' => { 'type' => "allow", 'url' => "/libs/granite/csrf/token.json*"},
        '0052' => { 'url'  => "/etc.clientlibs/*", 'type' => "allow" },
        '0053' => { 'glob' => "GET /libs/fd/*", 'type' => "allow" },
        '0054' => { 'glob' => "GET /libs/fd/af/runtime/clientlibs/*", 'type' => "allow"},
        '0055' => { 'glob' => "* /bin/xfaforms/submitaction*", 'type' => "allow" },
        '0056' => { 'glob' => "* /tmp/fd/*", 'type' => "allow"},
        '0057' => { 'url' => "/conf/jmh/settings/*", 'type' => "allow" }
      },
      :cache => {
        :docroot => node['cq']['dispatcher']['document_root'],
        :statfileslevel => 0,
        :allowAuthorized => 1,
        :rules => {
          '0000' => {
            :glob => '*',
            :type => 'allow'
          },
          '0001' => {
            :glob => '/content/prc/en/*',
            :type => 'deny'
          },
          '0002' => {
            :glob => '/content/dam/prc/*',
            :type => 'deny'
          },
          '0003' => {
            :glob => '/content/jmh/en/home/services/*',
            :type => 'deny'
          },
          '0004' => {
            :glob => '/content/jmh/en/home/doctor*',
            :type => 'deny'
          },
          '0005' => {
              :glob => '/content/jmh/en/home/for-physicians/screener*',
              :type => 'deny'
          }
        },
        :allowedClients => {
        },
        :invalidate => {
          '0000' => { :glob => '*', :type => 'deny' },
          '0001' => { :glob => '*.html', :type => 'allow' },
          '0002' => { :glob => '*.pdf', :type => 'allow' }
        }
      },
      :statistics => {
        :categories => {
          :html => { :glob => '*.html' },
          :others => { :glob => '*' }
        }
      }
    }
  }
}

