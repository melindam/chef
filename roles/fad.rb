name 'fad'
description 'FAD Role'

run_list(
  "role[base]",
  "recipe[jmh-fad]",
  "recipe[jmh-utilities::hostsfile_internal]"
)

override_attributes(
)
