# default['jmh_operations']['awstats']['version'] = 'awstats-7.7-1.noarch.rpm'
#
default['jmh_operations']['awstats']['packages'] = %w(perl-libwww-perl awstats)
default['jmh_operations']['awstats']['user'] = 'awstats'
default['jmh_operations']['awstats']['base_dir'] = '/usr/share/awstats'
default['jmh_operations']['awstats']['data_dir'] = '/var/lib/awstats'
default['jmh_operations']['awstats']['bin_dir'] = '/home/awstats/bin'
default['jmh_operations']['awstats']['webserver_logs_dir'] = '/home/awstats/webserver_logs'
default['jmh_operations']['awstats']['etcdir'] = '/etc/awstats'
default['jmh_operations']['awstats']['email'] = 'melinda.moran@johnmuirhealth.com'
default['jmh_operations']['awstats']['servers_databag'] = 'awstats'
