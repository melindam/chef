name 'encrypted'

description 'Encrypt a file system for application logs and mysql using lukscrypt'

run_list([
  "role[base]",
  "recipe[jmh-encrypt::lukscrypt]"
])

override_attributes(

)
