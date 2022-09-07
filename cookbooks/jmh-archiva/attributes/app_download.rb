default['jmh_archiva']['app_download']['group'] = 'devadmin'
default['jmh_archiva']['app_download']['app_dir'] = '/usr/local/webapps/mobile/download'
default['jmh_archiva']['app_download']['authuserfile'] = '/etc/httpd/auth_users'
default['jmh_archiva']['app_download']['databag']['name'] = 'jmh_archiva'
default['jmh_archiva']['app_download']['databag']['item'] = 'app_download'

default['jmh_archiva']['ebizrepo']['apache_config']['aliases']['/download'] = node['jmh_archiva']['app_download']['app_dir']

default['jmh_archiva']['ebizrepo']['legacy_authz_core'] = {'Order' => 'allow,deny','Allow' => 'from All'}
default['jmh_archiva']['app_download']['file_names'] = %w(manifest.plist SwiftChart.ipa)

default['jmh_archiva']['ebizrepo']['apache_config']['locations']['/download'] = {
  'Options' => '-Indexes',
  'AuthType' => 'Basic',
  'AuthName' => 'Restricted',
  'AuthBasicProvider' => 'file',
  'AuthUserFile' => node['jmh_archiva']['app_download']['authuserfile'],
  'Require' => 'valid-user'
}



