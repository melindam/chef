# This job runs echo import used by the mdsuspension application.
credentials = EncryptedDataBagItem.load(node['jmh_idev']['data_bag'],node['jmh_idev']['data_bag_item'])


template File.join('/home', node['jmh_operations']['backup']['user'], 'bin', 'import_mdsuspension_echo.sh') do
  source 'mdsuspension/import_echo_sh.erb'
  owner node['jmh_operations']['backup']['user']
  group node['jmh_operations']['backup']['user']
  mode '0700'
  variables(
      user: credentials['mdsuspension']['user'],
      password: credentials['mdsuspension']['password'],
      context: node['jmh_operations']['mdsuspension_import']['context'],
      base_url: node['jmh_operations']['mdsuspension_import']['domain'] ,
      success_phrase: node['jmh_operations']['mdsuspension_import']['success_phrase']
  )
end