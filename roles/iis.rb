name 'iis'

description 'IIS Installation'

run_list(
  "recipe[jmh-iis]"
)

override_attributes(
)
