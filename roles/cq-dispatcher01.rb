name 'cq-dispatcher01'
description 'Provides CQ dispatcher for node1 in failover environment'

run_list(
  "role[base]",
  "role[cq-dispatcher]"
)

override_attributes(
  :cq => {
    :dispatcher => {
      :publisher_role => 'cq-publisher01'
    }
  }
)