name "base"
description "Base role for Centos, RHEL, and Windows"

run_list([
  "recipe[jmh-server]"
])

override_attributes(
  :chef_client => {
    :server_url => "https://api.opscode.com/organizations/jmhebiz",
    :validation_client_name => "jmhebiz-validator"
  },
  :authorization => {
    :sudo => {
       :include_sudoers_d => true
       }
    }
)

