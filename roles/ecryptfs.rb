name 'ecryptfs'

description 'Encrypt a file system for application data'

run_list([
  "role[base]",
  "recipe[ecryptfs]"
])

override_attributes(
  :ecryptfs => { 
    :mount => '/data/ecryptfs', 
    :lower_directory => '/data/ecryptfs'
  }
)
