proxy_configs = {}

proxy_configs['proxy_passes'] = []
proxy_configs['proxy_pass_reverses'] = []
proxy_configs['locations'] = {}

proxy_index_page = []

node.default['jmh_webserver']['listen'] = [node['jmh_webproxy']['supportportal']['http']['port'],
                                      node['jmh_webproxy']['supportportal']['https']['port']]

include_recipe 'jmh-webserver'

# hostfile entry is used to make sensu tests work
hostsfile_entry '127.0.0.1' do
  hostname node['jmh_webproxy']['supportportal']['local_name']
  action :append
end


node['jmh_webproxy']['supportportal']['proxy'].each_key  do |proxy_key|
  Chef::Log.info("Building Proxy for: #{proxy_key}")
  proxy_site = node['jmh_webproxy']['supportportal']['proxy'][proxy_key]
  unless proxy_site['hide_link']
    link = proxy_site['link'] ? proxy_site['link'] : proxy_site['proxy_context']
    proxy_index_page.push('context' => link, 'description' => proxy_site['description'])
  end

  # If the proxy location is on the same server, no need to make a proxy
  skip_proxy = false
  if node['jmh_webproxy']['supportportal']['proxy'][proxy_key]['local_recipe']
    if node['recipes'].include?(node['jmh_webproxy']['supportportal']['proxy'][proxy_key]['local_recipe'])
      skip_proxy = true
    end
  end

  proxy_ip = 'localhost'

  proxy = Mash.new
  if skip_proxy
    next
  elsif Chef::Config['solo']
    proxy_configs['proxy_passes'].push("#{proxy_site['proxy_context']}  " \
                      "https://#{node['jmh_apps']['supportportal']['chef_solo_proxy_url']}:#{proxy_site['proxy_port']}#{proxy_site['proxy_context']}")
    proxy_configs['proxy_pass_reverses'].push("#{proxy_site['proxy_context']}  " \
                      "https://#{node['jmh_apps']['supportportal']['chef_solo_proxy_url']}:#{proxy_site['proxy_port']}#{proxy_site['proxy_context']}")
    proxy_configs['locations'][proxy_site['proxy_context']] = if node['jmh_webserver']['apache']['legacy_apache']
                                                                { 'Allow from' => 'All' }
                                                              else
                                                                { 'Require' => 'all granted' }
                                                              end
  else
    # Search for recipes within each node
    search(:node, "recipes:#{node['jmh_webproxy']['supportportal']['proxy'][proxy_key]['recipe']}") do |n|
      # If found in prod or stage, we want to capture that to be used for the apache proxies
      if node.environment == n.environment
        Chef::Log.info("Found #{n.name}  #{n['ipaddress']} to for #{proxy_key} to prod")
        proxy['server_name'] = n.name
        proxy_ip =  case
                    when node['jmh_webproxy']['supportportal']['proxy'][proxy_key]['ipaddress']
                      node['jmh_webproxy']['supportportal']['proxy'][proxy_key]['ipaddress']
                    when n['firehost'] && node['jmh_server']['jmh_local_server']
                      n['firehost']['nat_ip']
                    when n['cloud'] && node['jmh_server']['jmh_local_server']
                      n['cloud']['public_hostname']
                    else
                      n['ipaddress']
                    end
        proxy_address = if proxy_site['proxy_port']
                          "#{proxy_site['protocol']}://#{proxy_ip}:#{proxy_site['proxy_port']}#{proxy_site['proxy_context']}"
                        else
                          "#{proxy_site['protocol']}://#{proxy_ip}#{proxy_site['proxy_context']}"
                        end

        proxy_configs['proxy_passes'].push("#{proxy_site['proxy_context']}  #{proxy_address}")
        proxy_configs['proxy_pass_reverses'].push("#{proxy_site['proxy_context']}  #{proxy_address}")
        proxy_configs['locations'][proxy_site['proxy_context']] =  if node['jmh_webserver']['apache']['legacy_apache']
                                                                     { 'Allow from' => 'All' }
                                                                   else
                                                                     { 'Require' => 'all granted' }
                                                                   end
        break
      else
        Chef::Log.debug("Skipping #{n.name}  #{n['ipaddress']}")
      end
    end
  end
end

%w(http https).each do |protocol|
  params = node['jmh_webproxy']['supportportal']['apache']
  params = params.merge(node['jmh_webproxy']['supportportal'][protocol])
  if protocol == 'https'
    params['proxy_passes'] = proxy_configs['proxy_passes']
    params['proxy_pass_reverses'] = proxy_configs['proxy_pass_reverses']
    params['locations'] = proxy_configs['locations']
  else
    params['cond_rewrites'] = { "^/(.*) https://#{params['server_name']}%{REQUEST_URI} [NC,L]" => ['%{HTTPS} off'] }
  end

  Chef::Log.debug("Params for setup are: #{params}")

  jmh_webserver node['jmh_webproxy']['supportportal']['apache_name'] do
    apache_config params
    doc_root node['jmh_webproxy']['supportportal']['apache']['docroot']
  end
end

template File.join(node['jmh_webproxy']['supportportal']['apache']['docroot'], 'index.html') do
  source 'index_page.erb'
  owner node['apache']['user']
  group node['apache']['group']
  mode '0644'
  variables(
    :proxies => proxy_index_page
  )
end

directory File.join(node['jmh_webproxy']['supportportal']['apache']['docroot'], 'images') do
  user node['apache']['user']
  group node['apache']['group']
  action :create
end

images = %w(bullet.png header_commit.png logo_jmh.gif)

images.each do |fileimage|
  cookbook_file File.join(node['jmh_webproxy']['supportportal']['apache']['docroot'], 'images', fileimage) do
    source fileimage
    user node['apache']['user']
    group node['apache']['group']
    mode 0644
  end
end
