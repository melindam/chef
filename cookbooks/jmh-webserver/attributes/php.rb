
default['jmh_webserver']['php_prep']['yum_repo']['name'] = 'webtatic'
default['jmh_webserver']['php_prep']['yum_repo']['rpm'] = 'webtatic_repo_latest.rpm'
default['jmh_webserver']['php_prep']['yum_repo']['url'] = if JmhServerHelpers.rhel7?(node)
                                                            'https://mirror.webtatic.com/yum/el7/webtatic-release.rpm'
                                                          else
                                                            'http://mirror.webtatic.com/yum/el6/latest.rpm'
                                                          end
default['php']['remove_packages'] = %w(php56w php56w-xml php56w-common php56w-cli php56w-process
                                       php56w-pear php56w-devel)
default['jmh_webserver']['apache_mod_removals'] = %w(php5.load php5.conf)
default['php']['packages'] = %w(php71w-common php71w-devel php71w-cli php71w-pear mod_php71w)

default['jmh_webserver']['site_tag']['prod_env'] = 'arprod'
default['jmh_webserver']['site_tag']['dev_env'] = 'awsdev'
default['jmh_webserver']['site_tag']['node_query'] = 'recipes:jmh-webserver\:\:php_site'
