name 'cq-dispatcher02'
description 'Provides CQ dispatcher'

run_list(
  "role[base]",
  "role[cq-dispatcher]"
)

override_attributes(
  :cq => {
    :dispatcher => {
      :publisher_role => 'cq-publisher02'
    }
  }
)