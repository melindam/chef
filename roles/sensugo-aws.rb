name 'sensugo-aws'

description 'Creates the Sensugo Server in AWS'

run_list([
  "role[base]",
  "recipe[jmh-monitor::sensugo-backend]",
  "recipe[jmh-monitor::graphite]"
])


override_attributes(
 :jmh_monitor => {
    :sensugo => {
        :default_subscriptions => ["base","sensu-aws"]
    }
 }
)
