
node['jmh_webproxy']['tools'].each_key  do |proxy_key|

  Chef::Log.info("The Proxy is: #{proxy_key}")
  proxy_site = node['jmh_webproxy']['tools'][proxy_key]

  proxy_ip = "localhost"
  if proxy_site['proxy_ip']
      proxy_ip = proxy_site['proxy_ip']
  else
    search(:node, 'roles:' + proxy_site['search_role']) do |n|
      next unless node['jmh_webproxy']['tools'][proxy_key]['environment'] == n.environment
      proxy_ip = n['cloud'] ? n['cloud']['public_ipv4'] : n['ipaddress']
    end
  end

  proxy = Mash.new
  proxy['port'] = proxy_site['port']
  proxy['ip_address'] = '*'
  proxy['server_name'] = proxy_site['server_name']
  proxy['server_aliases'] = proxy_site['server_aliases'] ? proxy_site['server_aliases'] : nil
  proxy['app_server']= proxy_site['name']
  proxy['docroot'] = "/var/www/html"
  proxy['custom_log'] = proxy_site['custom_log'] ? proxy_site['custom_log'] : "logs/access.log combined"
  proxy['error_log'] = proxy_site['error_log'] ? proxy_site['error_log'] : "logs/error.log"


  if proxy_site['ssl']
    proxy['ssl'] = Mash.new
    proxy['ssl']['encrypted'] = true
    proxy['ssl']['data_bag'] = 'apache_ssl'
    proxy['ssl']['data_bag_item'] =  'johnmuirhealth_com_cert'
    proxy['ssl_pem_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.pem'
    proxy['ssl_key_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.key'
    proxy['ssl_chain_file'] = '/etc/httpd/ssl/johnmuirhealth_com_cert.chain'
    if proxy_site['protocol'] == "https"
      proxy['ssl_proxy_engine'] = "on"
    end
  end
  proxy['locations'] = proxy_site['locations'] ?  proxy_site['locations']: {"/" => [node['jmh_webserver']['security_all_allow']]}

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