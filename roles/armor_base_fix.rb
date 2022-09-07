name "armor_base_fix"
description "Base role for Centos and RHEL"

run_list([
  "role[base]"
])

override_attributes( 
  :jmh_server => {
    :armor => true
  },
  :chef_client => {
      :config => {
          "ohai.disabled_plugin" => "[:Passwd]"
      }
  }
)


