default['jmh_operations']['backup']['user'] = 'jmhbackup'
default['jmh_operations']['backup_root'] = '/backup'
default['jmh_operations']['encryption_backup_root'] = '/encrypted/backup'
default['jmh_operations']['prod_environment'] = 'arprod'

default['jmh_operations']['archivedb']['mysql_backup_dir'] = File.join(node['jmh_operations']['encryption_backup_root'], 'mysql_db_archive')
default['jmh_operations']['archivedb']['mongodb_backup_dir'] = File.join(node['jmh_operations']['encryption_backup_root'], 'mongodb_db_archive')

default['jmh_operations']['archivedb']['prod_backup_environments'] = ['arprod']
default['jmh_operations']['archivedb']['dev_backup_environments'] = %w(arstage awspoc awstst awstst2)

default['jmh_operations']['archivedb']['weekly']['retention'] = '+26'
default['jmh_operations']['archivedb']['weekly']['dailyfile'] = '0000'
default['jmh_operations']['archivedb']['mysql_search_query'] = 'recipes:jmh-db\:\:server'
default['jmh_operations']['archivedb']['mongodb_search_query'] = 'recipes:jmh-mongodb\:\:default'


default['jmh_operations']['slowquery']['database_hash'] = { "events": "recipes:jmh-events\\:\\:db",
                                                            "profile": "recipes:jmh-myjmh\\:\\:db",
                                                            "fad": "recipes:jmh-fad\\:\\:db",
                                                            "preregistration": "recipes:jmh-prereg\\:\\:db"
                                                            }

default['jmh_operations']['fad']['backup_dir'] = File.join(node['jmh_operations']['backup_root'], 'physician_images')
default['jmh_operations']['fad']['backup_environments'] = ['arprod', 'awstst2']
default['jmh_operations']['fad']['search_query'] = 'role:fad-master'
default['jmh_operations']['fad']['secondary_query'] = 'recipes:jmh-fad\:\:client AND NOT role:fad-master'
default['jmh_operations']['fad']['images_path'] = '/usr/local/webapps/fad/images'
default['jmh_operations']['fad']['client_query'] = 'recipes:jmh-fad\:\:db'

default['jmh_operations']['archiva']['backup_dir'] = File.join(node['jmh_operations']['backup_root'], 'archiva_data')
default['jmh_operations']['archiva']['backup_environment'] = 'arprod'

# Archive location for billpay files
# default['jmh_operations']['billpay']['backup_dir'] = File.join(node['jmh_operations']['encryption_backup_root'], 'billpay_files')
# default['jmh_operations']['billpay']['backup_environment'] = 'arprod'

default['jmh_operations']['cq']['backup_dir'] = File.join(node['jmh_operations']['backup_root'], 'cq_archive')

default['jmh_operations']['cq']['server_backups']['environment'] = 'arprod'
default['jmh_operations']['cq']['server_backups']['folder_name'] = 'server_backups'
default['jmh_operations']['cq']['server_backups']['servers'] = [{ 'name' => 'publisher', 'backup_name' => "#{node['cq']['publisher']['name']}-backup", 'search_query' => 'role:cq-publisher01' },
                                                                { 'name' => 'author', 'backup_name' => "#{node['cq']['author']['name']}-backup", 'search_query' => 'role:cq-author' }]
default['jmh_operations']['cq']['prod_packs']['folder_name'] = 'prod_packs'
default['jmh_operations']['cq']['prod_packs']['search_query'] = 'recipes:jmh-cq\:\:author AND chef_environment:' + node['jmh_operations']['cq']['server_backups']['environment']
# default['jmh_operations']['cq']['prod_packs']['search_query'] = 'recipes:jmh-cq\:\:scripts'
default['jmh_operations']['cq']['java_version'] = node['cq']['java_version']

default['subversion']['repo_dir'] = File.join(node['jmh_operations']['backup_root'],'svn')
default['jmh_operations']['subversion']['repo_download_url'] = 'http://ebiz-tools.hsys.local/share'
default['jmh_operations']['subversion']['repos'] = %w(ondemand jmmdhs)
default['jmh_operations']['subversion']['local_download'] = true
default['jmh_operations']['subversion']['crowd']['search'] = 'role:jmh-ebiz-crowd'
default['jmh_operations']['subversion']['crowd']['app'] = 'apache-ebiz-tools'

default['jmh_operations']['web_server']['apache_config80']['port'] = 80
default['jmh_operations']['web_server']['apache_config80']['ip_address'] = '*'
default['jmh_operations']['web_server']['apache_config80']['docroot'] = '/var/www/html'
default['jmh_operations']['web_server']['apache_config80']['server_name'] = 'ebiz-tools.hsys.local'
default['jmh_operations']['web_server']['apache_config80']['server_aliases'] = ['ebiz24.hsys.local']
default['jmh_operations']['web_server']['apache_config80']['cookbook'] = 'jmh-webserver'
default['jmh_operations']['web_server']['apache_config80']['custom_log'] = ['logs/access_log combined']
default['jmh_operations']['web_server']['apache_config80']['error_log'] = 'logs/error_log'

default['jmh_operations']['shared_folder']['root_directory'] = '/var/www'
default['jmh_operations']['share_directory'] = File.join(node['jmh_operations']['shared_folder']['root_directory'], 'share')

default['mysql']['version'] = '5.7' if node['platform_version'].start_with?('7.')
default['jmh_operations']['analytics']['db']['database'] = 'mychart'
default['jmh_operations']['analytics']['db']['bind_address'] = '0.0.0.0'
default['jmh_operations']['analytics']['redwagon']['user'] = 'redwagon'
default['jmh_operations']['analytics']['drop_location'] = '/var/redwagon'
default['jmh_operations']['analytics']['db_user'] = 'analytics_bot'

default['jmh_operations']['analytics']['sftp_salesforce_host'] = 'mcgnh6bszcv6-8z8v0wxwxcrcqf4.ftp.marketingcloudops.com'
default['jmh_operations']['analytics']['sftp_salesforce_user'] = 'jmhbackup'
default['jmh_operations']['analytics']['sftp_salesforce_remote_user'] = '100018725'
default['jmh_operations']['analytics']['sftp_salesforce_id_rsa'] = 'id_rsa_salesforce'

default['jmh_operations']['cert_check']['jdk_ignore_list'] = [ '6','7']

default['jmh_operations']['pingfed']['backup_dir'] = File.join(node['jmh_operations']['encryption_backup_root'], 'pingfed_archive')
default['jmh_operations']['pingfed']['remote_dir'] = '/usr/local/pingfederate/server/default/data/archive/'

default['jmh_operations']['stage_reset']['profile_mysql_user'] = 'profile_reset_user'
default['jmh_operations']['stage_reset']['profile_mysql_host'] = '127.0.0.1'
default['jmh_operations']['stage_reset']['profile_mysql_privileges'] = [:all]
default['jmh_operations']['stage_reset']['crowd_mysql_user'] = 'crowd_reset_user'
default['jmh_operations']['stage_reset']['crowd_mysql_host'] = '127.0.0.1'
default['jmh_operations']['stage_reset']['crowd_mysql_privileges'] = [:all]
default['jmh_operations']['stage_reset']['databag'] = ['operations','sso']

#  user we use is MYCHARTZD1
#  echo -n 'emp$MYCHARTZD1:<password>' | base64
# https://majgis.github.io/2017/09/13/Create-Authorization-Basic-Header/
default['jmh_operations']['interconnect_check']['basic_auth'] = 'ZW1wJE1ZQ0hBUlRaRDE6TXlDaEFyVFpk'

# default['jmh_operations']['jive_utilities']['data_bag'] = 'credentials'
# default['jmh_operations']['jive_utilities']['data_bag_item'] = 'nasjive'
# default['jmh_operations']['jive_utilities']['nas_mount_dir'] = '/usr/local/webapps/jive_utilities'
# default['jmh_operations']['jive_utilities']['install_dir'] = '/usr/local/nodeapp/jive_utilities'

default['jmh_operations']['mdsuspension_import']['domain'] = node['jmh_idev']['jmhweb']['apache']['server_name']
default['jmh_operations']['mdsuspension_import']['context'] = 'mdsuspension/physician/basic/importEcho'
default['jmh_operations']['mdsuspension_import']['success_phrase'] = 'Success!'

default['jmh_operations']['zipsync']['java_version'] = '11'
default['jmh_operations']['zipsync']['max_update_length'] = 500

default['jmh_operations']['videovisits']['backup_dir'] = File.join(node['jmh_operations']['encryption_backup_root'], 'video_visits_log_archive')
default['jmh_operations']['videovisits']['backup_environment'] = 'arprod'
default['jmh_operations']['videovisits']['api_search_query'] = 'recipes:jmh-vvisits\:\:vvisits_api'
