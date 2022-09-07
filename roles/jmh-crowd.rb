name 'jmh-crowd'

description 'Provides Crowd SSO service'

run_list([
  "role[base]",
  "recipe[jmh-crowd]",
  "recipe[jmh-db::db_backup]",
  "recipe[jmh-utilities::hostsfile_hsysdc]",
  "recipe[jmh-utilities::hostsfile_internal]"
])

override_attributes(
)
