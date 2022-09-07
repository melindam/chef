name 'idev-sbo'

description 'Builds IDEV Server app for SBO'

run_list(
  "role[jmh-local]",
  "recipe[jmh-idev::sbo]"
)

override_attributes(
  :jmh_tomcat => {
      :'7' => {
          :version => "7.0.52"
      }
  }
)
