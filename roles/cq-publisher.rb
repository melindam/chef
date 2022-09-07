name 'cq-publisher'
description 'Provides CQ publisher'

# TODO for dev run, still need to install via mvn local install
run_list(
  "role[base]",
  "recipe[jmh-cq::publisher]",
  "recipe[jmh-utilities::hostsfile_hsysdc]"
)

override_attributes(
)
