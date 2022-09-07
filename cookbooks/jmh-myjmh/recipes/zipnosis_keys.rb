directory node['jmh_myjmh']['zipnosis']['key_dir'] do
  recursive true
  action :create
end

include_recipe 'jmh-tomcat::user'
include_recipe 'jmh-myjmh::myjmh_private_key'

jmh_utilities_pem_to_der node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['name'] do
  databag_name node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_name']
  databag_item node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_item']
  databag_key_name node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['databag_key_name']
  secure_databag node['jmh_myjmh']['zipnosis']['public_zipnosis_ssh_key']['secure_databag']
  public_key true
  path node['jmh_myjmh']['zipnosis']['key_dir']
  owner node['jmh_tomcat']['user']
  group node['jmh_tomcat']['group']
  action node['jmh_myjmh']['zipnosis']['key_action']
end
