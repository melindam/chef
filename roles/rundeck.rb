name 'rundeck'

description 'Rundeck install'

run_list([
  "role[base]",
  "recipe[jmh-db::server]",
  "recipe[jmh-rundeck]",
])


override_attributes(
)