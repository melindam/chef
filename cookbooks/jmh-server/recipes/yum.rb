
include_recipe 'yum'

package 'yum-plugin-security' do
  package_name 'yum-plugin-security'
  action :install
end

include_recipe 'yum-epel'


