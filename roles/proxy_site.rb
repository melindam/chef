name 'proxy_site'

description 'Proxies various sites to be seen from the outside'

run_list(
  "role[base]",
  "recipe[jmh-webproxy::tools_proxy]",
  "recipe[jmh-utilities::hostsfile_www_servers]"
)