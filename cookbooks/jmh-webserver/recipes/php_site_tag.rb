
if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
  node.default['jmh_webserver']['site_tag']['webprodip']  = 'localhost'
  node.default['jmh_webserver']['site_tag']['webdevip'] = 'localhost'
else
  search(:node, node['jmh_webserver']['site_tag']['node_query']) do |n|
    if n.environment == node['jmh_webserver']['site_tag']['prod_env']
      node.default['jmh_webserver']['site_tag']['webprodip'] = n['firehost'] ? n['firehost']['nat_ip'] : n['ipaddress'] 
      break
    end
  end

  search(:node, node['jmh_webserver']['site_tag']['node_query']) do |n|
    if n.environment == node['jmh_webserver']['site_tag']['dev_env']
      node.default['jmh_webserver']['site_tag']['webdevip'] = n['cloud'] ? n['cloud']['public_hostname'] : n['ipaddress']
      break
    end
  end
end

directory File.join(node['jmh_webserver']['php']['sitetag']['apache_config']['docroot'], 'images') do
  recursive true
  user node['apache']['user']
  group node['apache']['group']
  action :create
end

template File.join(node['jmh_webserver']['php']['sitetag']['apache_config']['docroot'], 'index.php') do
  source 'site-tag/index_site_tag.erb'
  user node['apache']['user']
  group node['apache']['group']
  mode 0644
  variables(
    :webprodip => node['jmh_webserver']['site_tag']['webprodip'],
    :webdevip => node['jmh_webserver']['site_tag']['webdevip']
   )
end

images = %w(bullet.png header_commit.png logo_jmh.gif)

images.each do |fileimage|
  cookbook_file File.join(node['jmh_webserver']['php']['sitetag']['apache_config']['docroot'], 'images', fileimage) do
    source fileimage
    user node['apache']['user']
    group node['apache']['group']
    mode 0644
  end
end

directory node['jmh_webserver']['php']['sitetag']['apache_config']['cgibin'] do
  user node['apache']['user']
  group node['apache']['group']
  action :create
end

template File.join(node['jmh_webserver']['php']['sitetag']['apache_config']['cgibin'], 'tag.cgi') do
  source 'site-tag/tag_cgi.erb'
  user node['apache']['user']
  group node['apache']['group']
  mode 0755
  variables(
    :webprodip => node['jmh_webserver']['site_tag']['webprodip'],
    :webdevip => node['jmh_webserver']['site_tag']['webdevip']
  )
end

template File.join(node['jmh_webserver']['php']['sitetag']['apache_config']['cgibin'], 'update.cgi') do
  source 'site-tag/update_cgi.erb'
  user node['apache']['user']
  group node['apache']['group']
  mode 0755
  variables(
    :webprodip => node['jmh_webserver']['site_tag']['webprodip'],
    :webdevip => node['jmh_webserver']['site_tag']['webdevip']
  )
end

template File.join(node['jmh_webserver']['php']['sitetag']['apache_config']['cgibin'], 'compare.cgi') do
  source 'site-tag/compare_cgi.erb'
  user node['apache']['user']
  group node['apache']['group']
  mode 0755
  variables(
    :webprodip => node['jmh_webserver']['site_tag']['webprodip'],
    :webdevip => node['jmh_webserver']['site_tag']['webdevip']
  )
end
