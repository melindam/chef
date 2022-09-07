name 'pingfed'
description 'PingFederate Server Role'

run_list(
  "role[base]",
  "recipe[jmh-pingfed::pingfederate]",
  "recipe[jmh-utilities::hostsfile_www_servers]"
)

override_attributes(
)
