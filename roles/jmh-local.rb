name "jmh-local"
description "Defines local jmh server"

run_list([
  "role[base]"
])

override_attributes( 
  :jmh_server => {
    :jmh_local_server => true
  },
  :ntp => {
    :servers => ["172.18.8.5","172.18.8.6"]
  }
)