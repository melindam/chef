default['apache']['traceenable'] = 'Off'

# default['mysql']['old_passwords'] = 0
# default['mysql']['version'] = node['platform_version'].start_with?('7.') ? '5.7' : '5.1'
# default['mysql']['ssl']['directory'] = '/etc/mysql-default/ssl'
# default['mysql']['ssl']['data_bag'] = 'mysql'
# default['mysql']['ssl']['data_bag_item'] = 'cert'


default['jmh_apps']['apache']['ssl_protocol'] = node['platform_version'].start_with?('5.') ? '+TLSv1' : '+TLSv1 +TLSv1.1 +TLSv1.2'
default['jmh_apps']['apache']['ssl_cipher'] = 'ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:' +
                                              'DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:' +
                                              'ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:' +
                                              'DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:' +
                                              'AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:' +
                                              'DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4'
                                              
# default['jmh_apps']['apache']['mod_remoteip']['src_url'] = 'https://s3-us-west-1.amazonaws.com/jmhpublic/linux/apache-2.2-mod_remoteip.so'

# default['jmh_apps']['java_home'] = '/usr/lib/jvm/default-java'

# default['jmh_apps']['mysql']['bin_dir'] = '/usr/bin'

# default['jmh_apps']['default']['robots']['file'] = 'robots.txt'