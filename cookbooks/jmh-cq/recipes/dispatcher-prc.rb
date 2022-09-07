# PRC Site
# LWRP defined in the apache2 cookbook. Note at the bottom we call the
# commons we defined above to set those attributes in this resource
include_recipe 'jmh-cq::dispatcher'

prc_apache_config_bag = Chef::DataBagItem.load('apache_redirects', node['cq']['dispatcher']['prc']['prc_configs_data_bag'])

node.default['cq']['dispatcher']['prc']['http']['rewrites'] = prc_apache_config_bag['rewrites']
node.default['cq']['dispatcher']['prc']['http']['cond_rewrites'] =
    {'^/(.*) https://%{HTTP_HOST}%{REQUEST_URI} [NC,L]': node['cq']['dispatcher']['ssl_redirect_rewrite']}

http_mash = node['cq']['dispatcher']['prc']['common_http'].merge(node['cq']['dispatcher']['prc']['http'])

jmh_webserver 'aem dispatcher prc-http' do
  name 'prc'
  doc_root node['cq']['dispatcher']['prc']['common_http']['docroot']
  cookbook node['cq']['dispatcher']['prc']['common_http']['cookbook']
  apache_config http_mash
end

node.default['cq']['dispatcher']['prc']['https']['cond_rewrites'] =
    {'^/(.*)$ /content/prc/en/home/$1 [PT,L]' => prc_apache_config_bag['cq_ignore_content_https']}
node.default['cq']['dispatcher']['prc']['https']['rewrites'] = prc_apache_config_bag['rewrites_ssl']
node['cq']['dispatcher']['ssl']['apache']['prc'].each do |name, path|
  node.default['cq']['dispatcher']['prc']['https']["ssl_#{name}_file"] = path
end

https_mash = node['cq']['dispatcher']['prc']['common_http'].merge(node['cq']['dispatcher']['prc']['https'])

jmh_webserver 'aem dispatcher prc-https' do
  name 'prc'
  doc_root node['cq']['dispatcher']['prc']['common_http']['docroot']
  cookbook node['cq']['dispatcher']['prc']['common_http']['cookbook']
  apache_config https_mash
end