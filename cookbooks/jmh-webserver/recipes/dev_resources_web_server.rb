# creates dev-resources.johnmuirhealth.com 
node.default['jmh_webserver']['listen'] = [80]
jmh_webserver 'dev-resources' do
  apache_config node['jmh_webserver']['dev_tools_web_server']['apache_config80']
end


