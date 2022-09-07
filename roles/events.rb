name 'events'
description 'Events Role'

run_list(
  "role[base]",
  "recipe[jmh-events]"
)

override_attributes(
  :mysql => {
    :tunable => {
      :wait_timeout => '360'
    }
  }
)
