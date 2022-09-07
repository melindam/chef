# Add entries into /etc/hosts
# Roll through any entry by IP address and add other values

hostitem = data_bag_item(node['jmh_utilities']['hostsfiles']['databag'], 'hsysdc')

if hostitem['delete_hosts']
  hostitem['delete_hosts'].each_key do |delhostentry|
    delhost = hostitem['delete_hosts'][delhostentry].to_hash
    hostsfile_entry delhost['ip'] do
      hostname delhostentry
      action :remove
    end
  end
end

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
