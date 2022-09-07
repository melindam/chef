name 'prereg-client'

description 'Provides prereg client'

run_list([
  "role[base]",
  "recipe[jmh-prereg]",
  "recipe[jmh-utilities::hostsfile_internal]"
])

# TODO Prereg dev db user is root! Hard coded passwd in dev environment file
override_attributes(  
)
