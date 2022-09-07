name 'failover_site'

description 'Provides Failover site'

run_list(
  "role[base]",
  "recipe[jmh-webserver::failover_site]"
)

override_attributes(
)
