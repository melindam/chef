include_recipe 'apache2::mod_cgi'

local_directories = if node['jmh_webserver']['apache']['legacy_apache']
                      { 'Options' => '+ExecCGI -MultiViews +SymLinksIfOwnerMatch' }
                    else
                      { 'Options' => '+ExecCGI -MultiViews +SymLinksIfOwnerMatch',
                        'Require' => 'all Granted' }
                    end

web_app 'localhost' do
  cookbook 'jmh-webserver'
  ip_address '*'
  port 80
  server_name 'localhost'
  docroot '/var/www/html'
  script_aliases '/cgi-bin/' => '/var/www/cgi-bin/'
  directories '/var/www/cgi-bin' => local_directories
end

template '/var/www/cgi-bin/log_options.cgi' do
  source node['firehost'] ? 'log_options.cgi.erb' : 'log_options_cgi.erb'
  user 'root'
  group 'root'
  mode 0755
end

directory '/var/www/html/logs' do
  owner node['rundeck']['user']
  group node['rundeck']['user']
  action :create
end
