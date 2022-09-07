jenkins_url = '127.0.0.1'
jenkins_port = node['jenkins']['master']['port']

search(:node, 'recipes:jmh-ci\:\:jenkins') do |n|
  if n['ipaddress'] == node['ipaddress']
    break
  else
    if node['test_run'] && n['cloud']
      jenkins_url = n['cloud']['public_hostname']
    else
      jenkins_url = n['ipaddress']
    end
  end
end

node.default['jmh_bamboo']['web_server']['proxy_passes'] = node['jmh_bamboo']['web_server']['proxy_passes'] +
                                                            ["/jenkins http://#{jenkins_url}:#{jenkins_port}/jenkins"]
node.default['jmh_bamboo']['web_server']['proxy_pass_reverses'] = node['jmh_bamboo']['web_server']['proxy_passes'] +
                                                              ["/jenkins http://#{jenkins_url}:#{jenkins_port}/jenkins"]

jmh_webserver 'bamboo' do
  apache_config node['jmh_bamboo']['web_server']
  doc_root '/var/www/html'
end

template '/var/www/html/index.html' do
  source 'index_html.erb'
  action :create
end


