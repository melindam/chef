# 0.2

## 0.2.10

- removed appmetrics_dash_port
- updated cron to 1 hour for zoom_cleanup_period, but cleanup YAML entry to 2 hours

## 0.2.9

- included new zoom api local.yaml values

## 0.2.8

- included new cron for Zoom client licensing

## 0.2.7

- include service startup environment values
- moved cron sendReminders job to mongodb recipe for single node run

## 0.2.6

- updated app.js to be vvisits-api.js for startup script

## 0.2.5

- added yaml feature flag for 'emailIcs'

## 0.2.4

- upgrade to node 14

## 0.2.3

- included privacy email in local.yaml

## 0.2.2

- added mail server for override of mr1.hsys.local from developers
- added new URL for Zoom
- added user jmhbackup to nodejs group for archive log files rsync to work

## 0.2.1

- Added ability to add stuff to `vvisits_local_yaml.erb` via `['jmh_vvisits']['api']['added_properties']`

## 0.2.0

- find DB password via search recipe
- added port for appmetrics-dash for node stats

# 0.1

## 0.1.1

- mongodb URI string updates

## 0.1.0

- Initial creation of vvisits cookbook