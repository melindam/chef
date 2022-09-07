
# If there is a relay host defined, install the postfix client...unless you are the relay host
# else just install the default postfix


# Need to remove the exim project from Firehost Build
package "exim" do
  action :remove
end

package "mailx" do
  action :install
end

## Put the TLS Cert in place
tlsCertBag = Chef::EncryptedDataBagItem.load("postfix","tls")

directory "/etc/ssl" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

link "/etc/ssl/certs" do
  to "/etc/pki/tls/certs"
  action :create
end

link "/etc/ssl/private" do
  to "/etc/pki/tls/private"
  action :create
end


file "/etc/pki/tls/certs/ssl-cert-snakeoil.pem" do
  content tlsCertBag['pem']
  owner 'root'
  group 'root'
  mode 0600
  action :create
end

file "/etc/pki/tls/private/ssl-cert-snakeoil.key" do
  content tlsCertBag['key']
  owner 'root'
  group 'root'
  mode 0600
  action :create
end


postfix_recipe = 'postfix::default'

load_balancer_databag = Chef::EncryptedDataBagItem.load(node['jmh_server']['mail']['load_balancer_data_bag'][0],
                                                         node['jmh_server']['mail']['load_balancer_data_bag'][1])

# If local, forget about relays
if node['jmh_server']['jmh_local_server']
  node.default["postfix"]['main']["relayhost"] = node['jmh_server']['mail']['mail_relay']
elsif node['jmh_server']['use_mail_relay'] == true
  # if you are the the mail relay, set the variables correctly
  if node.run_list.roles.include?(node['postfix']['relayhost_role'])
    node.default['postfix']['main']['relayhost'] = node['jmh_server']['mail']['mail_relay']
    node.default['postfix']['main']['inet_interfaces'] = node['jmh_server']['mail']['inet_all']
    node.default['postfix']['use_relay_restrictions_maps'] = true
    env_servers = Hash.new
    load_balancer_databag.to_h.each do |lbname, lbvalue|
      next if lbname == 'id'
      env_servers["#{lbvalue['ip']}/32"] = 'OK'
    end
    if Chef::Config[:solo]
      Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
    else
      env_servers['127.0.0.0/8'] = 'OK'
      search(:node, "chef_environment:#{node.environment}") do |n|
        # check that it exists and it is a valid ipv4 address
        if n['ipaddress'] && !(IPAddr.new(n['ipaddress']) rescue nil).nil?
          Chef::Log.warn("Adding #{n.name} to the list of good relays")
          env_servers["#{n['ipaddress']}/32"] = 'OK'
        else
          Chef::Log.warn("Skipping #{n.name} because ip is bad")
        end

      end
    end
    node.default['postfix']['main']['mynetworks'] = env_servers.keys.join(" ")
  else
    postfix_recipe = 'postfix::client'
  end
end

include_recipe postfix_recipe