directory node['jmh_bamboo']['scratch_dir'] do
  action :create
end

include_recipe 'jmh-bamboo::install'
include_recipe 'jmh-bamboo::project_dependencies'
include_recipe 'jmh-bamboo::web_server'

if node['jmh_bamboo']['iptables']
  include_recipe 'iptables'
  iptables_rule 'bamboo'
end
