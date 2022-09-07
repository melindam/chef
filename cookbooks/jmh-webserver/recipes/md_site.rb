## THIS IS A DEPRECATED MODULE ##

jmh_webserver node['jmh_webproxy']['md']['apache_name'] do
  apache_config node['jmh_webproxy']['md']['apache']
  doc_root node['jmh_webproxy']['md']['apache']['docroot']
end
