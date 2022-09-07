include_recipe 'iptables'

package 'firewalld' do
  action :remove
end

service "iptables" do
  action :enable
end

iptables_rule 'jmh_server' do
  enable true
end

if node['jmh_server']['armor']
  iptables_rule 'armor_server' do
    source 'armor_server.erb'
    enable true
    variables(
      dmz: node['jmh_server']['armor_dmz']
    )
  end
end
