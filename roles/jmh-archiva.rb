name 'jmh-archiva'
description 'Archiva Role'


run_list(
  "role[base]",
  "recipe[jmh-archiva]"
)


