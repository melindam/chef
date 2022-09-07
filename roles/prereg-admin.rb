name 'prereg-admin'

description 'Provides prereg admin'

run_list(
  "role[base]",
  "recipe[jmh-prereg::admin]",
  "recipe[jmh-utilities::hostsfile_internal]"    
)
override_attributes(  
)
