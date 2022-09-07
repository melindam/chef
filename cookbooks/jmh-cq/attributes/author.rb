default['cq']['author']['name'] = "author01-#{node['cq']['cq_s3_key'].gsub(/[^0-9]/,'')}"
default['cq']['author']['max_memory'] =  (%w(prod stage).include? node['jmh_server']['environment']) ? '4096m' : '2048m'
default['cq']['author']['min_memory'] =  (%w(prod stage).include? node['jmh_server']['environment']) ? '4096m' : '2048m'
default['cq']['author']['port'] = 4502
default['cq']['author']['interface'] = nil
default['cq']['author']['mode'] = 'author'
default['cq']['author']['environment'] =  case node['jmh_server']['environment']
                                          when 'prod'
                                            'prod'
                                          when 'stage'
                                            'stage'
                                          else
                                            'dev'
                                           end
default['cq']['author']['show_sample_content'] = %w(prod stage).include?(node['cq']['author']['environment']) ? false : true
default['cq']['author']['disable_tar_compaction'] = false

default['cq']['author']['max_open_files'] = 50_000
default['cq']['author']['6.5']['bundles'] = [ { 'name' => 'acs-aem-commons-ui.apps-4.5.0.zip',
                                                'file_location' => 'bundles',
                                                'package_location' => '/crx/packmgr/service/.json/etc/packages/adobe/consulting',
                                                'delay' => 20,
                                                'restart' => false
                                              }]
default['cq']['author']['content_assets'] = ['author/jmhbackup-content-jmh.zip',
                                             'author/jmhbackup-dam-jmh-documents-a-m.zip',
                                             'author/jmhbackup-dam-jmh-documents-n-z.zip',
                                             'author/jmhbackup-dam-jmh-no-documents.zip',
                                             'author/jmhbackup-content-prc.zip',
                                             'author/jmhbackup-dam-prc.zip',
                                             'author/jmhbackup-forms.zip'
                                             ]

default['cq']['author']['asset_zips'] = []
default['cq']['author']['asset_checksums'] = {}
default['cq']['author']['jmx_port'] = 6962
default['cq']['author']['check_page']['url_suffix'] = '/libs/granite/core/content/login.html'

default['cq']['author']['apache']['server_name'] = ''

default['cq']['author']['apache_ssl']['port'] = 443
default['cq']['author']['apache_ssl']['ip_address'] = '*'
default['cq']['author']['apache_ssl']['docroot'] = node['cq']['dispatcher']['document_root']

default['cq']['author']['apache_ssl']['app_server'] = 'cq-author'
default['cq']['author']['apache_ssl']['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
default['cq']['author']['apache_ssl']['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
default['cq']['author']['apache_ssl']['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'
default['cq']['author']['apache_ssl']['proxy_passes'] = ['/  http://localhost:4502/']
default['cq']['author']['apache_ssl']['proxy_pass_reverses'] = ['/  http://localhost:4502/']
default['cq']['author']['apache_ssl']['locations'] = { '/' => [node['jmh_webserver']['security_all_allow']] }
default['cq']['author']['apache_ssl']['ssl']['data_bag'] = 'apache_ssl'
default['cq']['author']['apache_ssl']['ssl']['data_bag_item'] = 'johnmuirhealth_com_cert'
default['cq']['author']['apache_ssl']['ssl']['encrypted'] = true
default['cq']['author']['apache_ssl']['proxy_preserve_host'] = 'On'

default['cq']['author']['apache80']['port'] = 80
default['cq']['author']['apache80']['ip_address'] = '*'
default['cq']['author']['apache80']['docroot'] = node['cq']['dispatcher']['document_root']
default['cq']['author']['apache80']['app_server'] = 'cq-author'
default['cq']['author']['apache80']['rewrite_log'] = '/var/log/httpd/rewrite.log'
default['cq']['author']['apache80']['rewrite_log_level'] = 1
default['cq']['author']['apache80']['cond_rewrites'] = { '^/(.*) https://%{HTTP_HOST}%{REQUEST_URI} [NC,L]' => ['%{HTTPS} off'] }
