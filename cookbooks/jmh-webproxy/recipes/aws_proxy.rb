node.default['jmh_webserver']['listen'] = [443]

include_recipe 'jmh-webserver'

# Take care of hostfile proxy legwork

node['jmh_webproxy']['hostfile_proxy'].each_key do |hostfile_key|
  # Get Shared Hostfile Proxy Ip
  unless Chef::Config['solo']
    search(:node, 'recipes:' + node['jmh_webproxy']['hostfile_proxy'][hostfile_key]['search_recipe']) do |n|
      hostfile_ip = n['cloud'] ? n['cloud']['public_ipv4'] : n['ipaddress']
      hostfile_array = []
      node['jmh_webproxy']['aws'].each_key do |proxy_key|
        next unless node['jmh_webproxy']['aws'][proxy_key]['hostfile_proxy'] == hostfile_key &&
                    node['jmh_webproxy']['aws'][proxy_key]['environment'] == n.environment
        unless hostfile_array.include?(node['jmh_webproxy']['aws'][proxy_key]['proxy_domain'])
          hostfile_array.push(node['jmh_webproxy']['aws'][proxy_key]['proxy_domain'])
        end
      end

      Chef::Log.warn("host array: #{hostfile_array}")
      Chef::Log.warn("host ip: #{hostfile_ip}")
      # Create hostsfile
      if hostfile_array.size() > 0
        hostfile_primary = hostfile_array.pop
        hostsfile_entry hostfile_ip do
          hostname hostfile_primary
          aliases hostfile_array unless hostfile_array.size() == 0
          action :create
        end
      end
    end
  end
end

node['jmh_webproxy']['aws'].each_key  do |proxy_key|
  Chef::Log.info("The Proxy is: #{proxy_key}")
  proxy_site = node['jmh_webproxy']['aws'][proxy_key]

  # cloud.public_hostname
  proxy_ip = 'localhost'
  # If it has a proxy_ip already, just use that
  if proxy_site['proxy_ip']
    proxy_ip = proxy_site['proxy_ip']
  # If it wants you to create a hostsfile proxy, then put the ip in the hostfiles
  elsif proxy_site['hostfile_proxy']
    proxy_ip = proxy_site['proxy_domain']
  # Put the ip in the apache config file
  else
    if proxy_site['search_recipe'].nil?
      Chef::Application.fatal!("No search for #{proxy_site}")
    end
    unless Chef::Config['solo']
      search(:node, 'recipes:' + proxy_site['search_recipe']) do |n|
        if n.environment == proxy_site['environment']
          proxy_ip = n['cloud'] ? n['cloud']['public_hostname'] : n['ipaddress']
          break
        end
      end
    end
  end

  proxy = Mash.new
  proxy['port'] = proxy_site['port']
  proxy['ip_address'] = '*'
  proxy['server_name'] = proxy_site['server_name']
  proxy['server_aliases'] = proxy_site['server_aliases'] ? proxy_site['server_aliases'] : nil
  proxy['app_server'] = proxy_site['name']
  proxy['docroot'] = '/var/www/html'
  proxy['custom_log'] = proxy_site['custom_log'] ? proxy_site['custom_log'] : 'logs/access.log combined'
  proxy['error_log'] = proxy_site['error_log'] ? proxy_site['error_log'] : 'logs/error.log'

  if proxy_site['enable_ssl']
    proxy['ssl'] = Mash.new
    proxy['ssl']['encrypted'] = true
    if proxy_site['ssl']
      proxy['ssl']['data_bag'] = proxy_site['ssl']['data_bag']
      proxy['ssl']['data_bag_item'] = proxy_site['ssl']['data_bag_item']
      proxy['ssl_pem_file'] = proxy_site['ssl']['pem_file']
      proxy['ssl_key_file'] = proxy_site['ssl']['key_file']
      proxy['ssl_chain_file'] = proxy_site['ssl']['chain_file']
    else
      proxy['ssl']['data_bag'] = 'apache_ssl'
      proxy['ssl']['data_bag_item'] = 'johnmuirhealth_com_cert'
      proxy['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
      proxy['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
      proxy['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'
    end
    proxy['ssl_proxy_engine'] = 'on' unless proxy_site['protocol'] != 'https'
  end
  proxy['locations'] = proxy_site['locations'] ? proxy_site['locations'] : { '/' => [node['jmh_webserver']['security_all_allow']] }

  proxy_address = proxy_site['proxy_port'] ? "#{proxy_site['protocol']}://#{proxy_ip}:#{proxy_site['proxy_port']}#{proxy_site['proxy_context']}" :
                                             "#{proxy_site['protocol']}://#{proxy_ip}#{proxy_site['proxy_context']}"
  proxy['proxy_passes'] = ["#{proxy_site['proxy_context']}  #{proxy_address}"]
  proxy['proxy_pass_reverses'] = ["#{proxy_site['proxy_context']}  #{proxy_address}"]

  jmh_webserver proxy_site['name'] do
    apache_config proxy
    cookbook 'jmh-webserver'
    doc_root proxy['docroot']
  end
end
