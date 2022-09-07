name "profile"
description "Installs Java Oracle flavor, and tomcat with application location for Consumer Profile"

run_list([
  "role[base]",
  "recipe[jmh-apps::profile]",
  "recipe[jmh-utilities::hostsfile_epic_servers]",
  "recipe[jmh-utilities::hostsfile_www_servers]",
  "recipe[jmh-utilities::hostsfile_profile_servers]"
])

override_attributes(
)