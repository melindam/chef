# Add entries into /etc/hosts
# Roll through any entry by IP address and add other values

%w(epic_servers hsysdc internal myjmh_servers ssh1 www_servers cloverleaf_servers).each do |bad_data_bag_name|
  badhostitem = data_bag_item('hostsfile', bad_data_bag_name)
  badhostitem['hosts'].each_key do |badhostentry|
    badhost = badhostitem['hosts'][badhostentry].to_hash

    hostsfile_entry badhost['ip'] do
      action :remove
    end
  end
end
