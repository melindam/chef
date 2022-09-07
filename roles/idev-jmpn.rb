name 'idev-jmpn'

description 'Builds IDEV Server app for JMPN'

run_list(
  "role[jmh-local]",
  "recipe[jmh-idev::jmpn]"
)

override_attributes(
  :jmh_tomcat => {
      :'7' => {
          :version => "7.0.52"
      }
  }
)
