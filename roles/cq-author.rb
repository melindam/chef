name 'cq-author'
description 'Provides CQ author'

run_list(
  "role[base]",
  "recipe[jmh-cq::author]",
  "recipe[jmh-cq::author-apache]",
  "recipe[jmh-utilities::hostsfile_hsysdc]"
)

override_attributes(
)
