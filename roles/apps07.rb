name "apps07"
description "Installs application location for MyJMH"


run_list([
  "role[base]",
  "recipe[jmh-myjmh::profile-client]",
  "recipe[jmh-myjmh::profile_api]",
  "recipe[jmh-webserver::mychart_proxy]",
  "recipe[jmh-utilities::hostsfile_hsysdc]"

])

override_attributes(
)