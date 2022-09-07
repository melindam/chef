name 'idev-hr'

description 'Builds IDEV Server app for HR'

run_list(
  "role[jmh-local]",
  "recipe[jmh-idev::hr]"
)

override_attributes(
    "jmh_tomcat": {
        "7": {
            "version": "7.0.52"
        }
    }
)
