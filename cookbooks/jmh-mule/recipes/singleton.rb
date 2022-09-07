# Mule singleton test

jmh_mule node['jmh_mule']['singleton']['name'] do
  name node['jmh_mule']['singleton']['name']
  iptables node['jmh_mule']['singleton']['iptables']
  app_properties node['jmh_mule']['singleton']['app_properties'] 
end  