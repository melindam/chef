# Used to get the java home for now
require 'chef/data_bag_item'
module JmhPingFed
  class << self
    def get_pingfed_client_secret(client, node)
      data_bag_item =  Chef::EncryptedDataBagItem.load(node['jmh_pingfed']['databag']['name'], node['jmh_pingfed']['databag']['item'] )
      current_environment = node['jmh_server']['environment']
      if data_bag_item['client_secret'][client][current_environment]
        return data_bag_item['client_secret'][client][current_environment]
      else
        return data_bag_item['client_secret'][client]['default']
      end
    end
  end
end

