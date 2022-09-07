
include_recipe "jmh-fad::client"


echo_databag = data_bag_item('jmh_apps','fad_echo')

template File.join('/home/tomcat/bin', 'echo_file_update.rb') do
  source 'update_echo_file_rb.erb'
  mode 0744
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  variables(
    echo_folder: node['jmh_fad']['client']['upload']['folder'],
    echo_file_name: node['jmh_fad']['client']['upload']['import_file_name'],
    jmpn_removal_list: echo_databag['jmpn_removal_list'],
    addition_list: echo_databag['addition_list'],
    removal_list: echo_databag['removal_list']
  )
  action :create
end
