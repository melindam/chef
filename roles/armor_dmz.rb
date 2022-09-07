name "armor_dmz"
description "Base role for Centos and RHEL"

run_list([
  "role[base]"
])

override_attributes( 
  :jmh_server => {
    :armor => true,
    :armor_dmz => true
  }
)


