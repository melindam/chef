name 'idev-mdsuspension'

description 'Builds IDEV Server app for MD Suspension'

run_list(
  "role[jmh-local]",
  "recipe[jmh-idev::mdsuspension]"
)

override_attributes(
    :jmh_tomcat => {
        :'7' => {
            :version => "7.0.52"
        }
    }
)
