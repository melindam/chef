name "jmh-local-no-awsvpn"
description "Defines local jmh server without access to aws vpn tunnel"

run_list([
  "role[jmh-local]"
])

override_attributes(
  :jmh_server => {
    :no_awsvpn_traffic => true
  }
)