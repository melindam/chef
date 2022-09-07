# Add entries into /etc/hosts
# Roll through any entry by IP address and add other values

hostitem = data_bag_item(node['jmh_utilities']['hostsfiles']['databag'], 'ssh1')
hostitem['hosts'].each_key do |hostentry|
  newhost = hostitem['hosts'][hostentry].to_hash

  hostsfile_entry newhost['ip'] do
    hostname hostentry
    aliases newhost['alias'] || []
    unique true
    comment newhost['comments'] || ''
    action :create
  end
end
