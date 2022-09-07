# jmh-monitor cookbook

# Requirements
RHEL/CENTOS

# Readings
- SensuGo - https://docs.sensu.io/sensu-go/latest/

# Attributes
`['jmh_monitor']['sensugo_server']['role'] ` - role used to find sensu-server to use

# Recipes
`jmh-monitor::sensugo-backend` - installs sensu-server
`jmh-monitor::sensugo-agent` - installs sensu client
`jmh-monitor::graphite` - installa graphite for use with sensu
# Author

Author:: Scott Marshall (scott.marshall@johnmuirhealth.com)

# Filters

(https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-filter/filters/)

Before executing a handler, the Sensu backend will apply any event filters configured for the handler to the observation data in events. If the filters do not remove the event, the handler will be executed.

## Current Filters
* built in filters: is_incident, not_silenced, has_metrics - (https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-filter/filters/#built-in-event-filters)
* fatigue-check-filter - delays notifications to limited amount of emails (https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-filter/reduce-alert-fatigue/)
* aem-maintenance - silences emails during the weekly garbage collection and restart of aem 
* business_hours_only - dont send emails during night for development systems
* sup-maintenance - silences SUP downtime for daily refresh
* fad-maintenance - silences FAD downtime during daily echo update

# Handlers 

(https://docs.sensu.io/sensu-go/latest/observability-pipeline/observe-process/handlers/)

Handlers are actions the Sensu backend executes on events.

## Current Handlers
* email-handler - send an email on failing/passing
    * aem-email-handler - appends aem-maintenance filter
    * fad-email-handler - not used
    * sup-email-handler - appends sup-maintenance filters
* graphite - sends metrics to graphite
* pagerduty-handler - creates and closes pagerduty incidents
* keepalive - will page out using pagerduty if a server does not respond.

# Changing sensugo password

1. Update the attribute, `['jmh_monitor']['sensugo']['new_admin_password']`, with you new password
1. run chef-client on all servers/clients using the same sensugo server.  The jobs will fail, but update the password
1. Update the attribute, `['jmh_monitor']['sensugo']['admin_password']`, with the new password
1. run chef-client again.
Note: the password needs to be at least 8 characters


