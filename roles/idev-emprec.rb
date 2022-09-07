name 'idev-emprec'

description 'Builds IDEV Server app for Employee Recognition'

run_list(
  "role[jmh-local]",
  "recipe[jmh-idev::emprec]"
)

override_attributes(
  :mysql => {
    :bind_address => "0.0.0.0"
  },
  :jmh_tomcat => {
      :'7' => {
          :version => "7.0.52"
      }
  }
)
