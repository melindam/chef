# Used by registration app to get content in place for updates by bamboo

include_recipe 'jmh-webserver'

directory File.join("/home", node['jmh_webserver']['webcommon']['user'], 'bin') do
  path File.join("/home", node['jmh_webserver']['webcommon']['user'] , 'bin')
  owner node['jmh_webserver']['webcommon']['user']
  group node['jmh_webserver']['webcommon']['group']
  mode '0755'
  action :create
end


template File.join("/home", node['jmh_webserver']['webcommon']['user'], 'bin', 'deploy_webcommon.sh') do
  source "webcommon/deploy_webcommon_sh.erb"
  owner node['jmh_webserver']['webcommon']['user']
  group node['jmh_webserver']['webcommon']['group']
  mode '0755'
  variables(
    :content_dir => node['jmh_webserver']['webcommon']['docroot_dir'],
    :path => node['jmh_webserver']['webcommon']['content_dir'],
    :home_dir => File.join("/home", node['jmh_webserver']['webcommon']['user'])
  )
end

webcommon_path = File.join(node['jmh_webserver']['webcommon']['docroot_dir'], node['jmh_webserver']['webcommon']['content_dir'])
directory "webcommon root content directory" do
  path webcommon_path
  owner node['jmh_webserver']['webcommon']['user']
  group node['jmh_webserver']['webcommon']['group']
  mode '0755'
  action :create
end

# Create location and config file
directory '/home/jmhbackup/webcommon-cfg' do
  owner node['jmh_webserver']['webcommon']['user']
  group node['jmh_webserver']['webcommon']['group']
  mode '0755'
  action :create
end

# Add NEW configs to both template files below
template '/home/jmhbackup/webcommon-cfg/api-config.js' do
  source "webcommon/api-config.js.erb"
  owner node['jmh_webserver']['webcommon']['user']
  group node['jmh_webserver']['webcommon']['group']
  mode '0755'
  variables(
    :www_server_name => if node['test_run']
                          "#{node['jmh_server']['global']['apache']['www']['server_name']}:#{node['jmh_webserver']['test_run']['port']}"
                        else
                          node['jmh_server']['global']['apache']['www']['server_name']
                        end,
    :api_server_name => if node['test_run']
                          "#{node['jmh_server']['global']['apache']['api']['server_name']}:#{node['jmh_webserver']['test_run']['port']}"
                        else
                          node['jmh_server']['global']['apache']['api']['server_name']
                        end,
    :idp_server_name => node['jmh_server']['global']['apache']['idp']['server_name'],
    :supportportal_server_name => node['jmh_server']['global']['apache']['supportportal']['server_name'],
    :google_captcha_site_key => node['jmh_server']['global']['google_captcha_site_key'],
    :google_maps_api_key => node['jmh_server']['global']['google_maps_api_key'],
    :google_api_key => node['jmh_server']['global']['google_api_key'],
    :google_uc_doc_maps_api_key => node['jmh_server']['global']['google_uc_doc_maps_api_key'],
    :google_analytics_id => node['jmh_server']['global']['google_analytics_id'],
    :patient_portal_url => node['jmh_server']['global']['patientportal']['url'],
    :portal_name => node['jmh_server']['global']['patientportal']['name'],
    :numschedulingdays => node['jmh_webserver']['webcommon']['numschedulingdays'],
    :google_analytics_id_vvisits => node['jmh_server']['global']['google_analytics_id_vvisits'],
    :vvisits_time_allowance => node['jmh_webserver']['vvisits_client']['vvisits_time_allowance'],
    :tealium_reportsuite_id => node['jmh_server']['global']['tealium_reportsuite_id'],
    :tealium_profile => node['jmh_server']['global']['tealium_profile'],
    :tealium_account => node['jmh_server']['global']['tealium_account'],
    :tealium_environment => node['jmh_server']['global']['tealium_environment'],
    :tealium_datasource => node['jmh_server']['global']['tealium_datasource']
  )
end

apiconfig_file=File.join( webcommon_path, 'config/api-config.js')
if File.exists?(apiconfig_file)
  file apiconfig_file do
    content lazy{File.open('/home/jmhbackup/webcommon-cfg/api-config.js').read}
    owner node['jmh_webserver']['webcommon']['user']
    group node['jmh_webserver']['webcommon']['group']
    mode '0755'
  end
end
