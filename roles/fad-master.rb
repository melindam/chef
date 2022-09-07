name 'fad-master'
description 'FAD Role'

run_list(
  "role[base]",
  "recipe[jmh-fad::client]",
  "recipe[jmh-utilities::hostsfile_internal]"
)

override_attributes(
    :jmh_fad => {
        :master_server => true
    }
)
