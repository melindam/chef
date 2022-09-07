#!/usr/bin/env ruby
# Author: Scott Marshall
# name: update_lb_pool.rb
# Description: Updates a node in a pool to a state you request
# https://community.pulsesecure.net/t5/Pulse-Secure-vADC/Tech-Tip-Using-the-RESTful-Control-API-with-Ruby-startstopvs/ta-p/28920
require 'rest_client'
require 'json'
require 'optparse'

adminuser = 'apiuser'
adminpassword = '******'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: update_lb_pool.rb [options]"
  opts.separator ""
  opts.separator "Specific options:"
  opts.on('-p', '--poolname [name of pool]', 'Pool Name') { |v| options['poolname'] = v }
  opts.on('-s', '--statechange [active,disabled,draining]', 'Pool State Change DEFAULT: active') { |v| options['stagechange'] = v }
  opts.on('-n', '--nodeserver [127.0.0.1:443]', 'Node Server ') { |v| options['nodeserver'] = v }
  opts.on('-l', '--lbip [127.0.0.1]', 'Load Balancer IP DEFAULT: 100.68.181.14') { |v| options['lbip'] = v }
  opts.on('-h', '--help', 'Help') { puts opts
  exit }
end.parse!

# p options

help_message = 'try update_lb_pool.rb -h for more information'

abort("A pool name needs to be defined. #{help_message}") unless options['poolname']
pool=options['poolname']

abort("Server Node Needs to be defined. #{help_message}") unless options['nodeserver']
node_ip = options['nodeserver'] if options['nodeserver']

state_change= options['stagechange'] ? options['stagechange'] : 'active'
lb_ip= options['lbip'] ? options['lbip'] : '100.68.181.14'

url = "https://" + lb_ip + ":9070/api/tm/3.8/config/active/pools/" + URI.escape(pool)

begin

  # Get the config data for the virtual server
  response = RestClient::Request.execute(url: url,
                                         method: :get,
                                         verify_ssl: false,
                                         user: adminuser,
                                         password: adminpassword
                                         )
  # Decode the json response.  The result will be a hash
  poolConfig = JSON.parse(response.body)
  # puts poolConfig.to_s
  nodes = poolConfig['properties']['basic']['nodes_table']
  new_node_table = Array.new
  found = false
  nodes.each do |current_node|
    # puts current_node['node']
    if current_node['node'] == node_ip
      puts "Node Found! #{node_ip} - #{current_node['state']}"
      if current_node['state'] != state_change
        puts "State is not #{state_change}.  Need to set to #{state_change}"
        found = true
        new_node_table.push({'node' => node_ip,
                             'state' => state_change})
      end
    else
      new_node_table.push(current_node)
    end
  end

  response = RestClient::Resource.new(url,
                                      verify_ssl: false,
                                      user: adminuser,
                                      password: adminpassword)
  disabledPoolConfig = { 'properties' => {'basic' => {'nodes_table' => new_node_table}}  }
  if found
    response.put(JSON.generate(disabledPoolConfig), content_type: :json)
    puts "Node set to #{state_change}"
  else
    puts "Node not found or already in state #{state_change}"
  end

rescue => e
  puts "Error: URL=#{url} Error: #{e.message}"
end