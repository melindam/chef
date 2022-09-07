name 'cq-frontend'
description 'Provides CQ publisher and dispatcher'

# TODO for dev run, still need to install via mvn local install
run_list(
  "role[base]",
  "recipe[jmh-cq::publisher]",
  "recipe[jmh-cq::dispatcher]"
)

override_attributes(
  :cq => {
      :dispatcher => {
          :publisher_role => "cq-frontend"
      }
  }
)
