 #!/usr/bin/env ruby

 # Example application to demonstrate some basic Ruby features
 # This code loads a given file into an associated application
require "ridley"

class Autodoc
  
  def initialize 
    Ridley::Logging.logger.level = Logger.const_get 'ERROR'
    @ridley = Ridley.from_chef_config(".chef/knife.rb")
    @fhost_data_bag = @ridley.data_bag.find("firehost")
    @fhost_db_item = @fhost_data_bag.item.find("servers")
    
    #server_list = get_servers_with_role_by_environment("apps01","fhprod")
    proxy_list = ["api_proxies",
          "billpay_proxies",
          "event_proxies",
          "fad_proxies",
          "prereg_proxies", 
          "profile_proxies",
          "myjmh_proxies",
          "subsite_proxies",
          "webrequest_proxies"]
    get_application_server_port_list(proxy_list, "fhprod")
    
    exit
  end
  
  def get_servers_with_role_by_environment current_role, current_env
    env_servers = Array.new

    nodes = @ridley.node.all
    nodes.each do |c| 
        my_node = @ridley.node.find(c.chef_id)
        if my_node.chef_environment == current_env
          #print "#{my_node.chef_id} #{my_node.chef_environment}\n"
          if my_node.run_list.include?("role[#{current_role}]")
           # print "#{my_node.chef_id} #{my_node.chef_environment}\n"
            env_servers.push(my_node)  
            break      
          end
        end
     end  
     return env_servers
  end
  
  def get_application_server_port_list proxy_list, current_env
    data_bag = @ridley.data_bag.find("apache_redirects")
    proxy_list.each do |app_proxy|
      data_item = data_bag.item.find(app_proxy)
      servers = get_servers_with_role_by_environment(data_item['target_role'],current_env)
      data_item['proxies'].each do |prxy,dest|
        print "#{@fhost_db_item['servers'][servers[0].chef_attributes['ipaddress']]['firehost_name']},"
        print "#{prxy[1..-1]},"
        print "#{data_item['proto'] ? data_item['proto'] : 'http'}://#{servers[0].chef_attributes['ipaddress']}:#{data_item['port']}#{prxy},"
        print "/etc/init.d/#{prxy[1..-1]}\n"
      end
    end
  end

end

autodoc = Autodoc.new

