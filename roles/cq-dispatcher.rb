name 'cq-dispatcher'
description 'Provides CQ dispatcher'

run_list(
  "role[base]",
  "recipe[jmh-cq::dispatcher]",
  "recipe[jmh-webserver::app_widgets]",
  "recipe[jmh-webserver::webcommon]",
  "recipe[jmh-webserver::idp]",
  "recipe[jmh-webserver::vvisits_client]",
  "recipe[jmh-utilities::hostsfile_www_servers]"
)

override_attributes(
)

