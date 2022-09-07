# gets updated in the dispatcher.rb run
default['cq']['app_proxies']['mychartsso_proxies']['id'] = 'mychartsso_proxies'
default['cq']['app_proxies']['mychartsso_proxies']['target_recipe'] = 'jmh-webserver\\:\\:mychart_proxy'
default['cq']['app_proxies']['mychartsso_proxies']['proxies'] = {"/MyChart" => "/MyChart" }
default['cq']['app_proxies']['mychartsso_proxies']['port'] = 443
default['cq']['app_proxies']['mychartsso_proxies']['proto'] = 'https'
default['cq']['app_proxies']['mychartsso_proxies']['maintenance'] = false
default['cq']['app_proxies']['mychartsso_proxies']['maintenance_page'] = '/jmherror/myjmh_maintenance.html'
default['cq']['app_proxies']['mychartsso_proxies']['maintenance_windows'] = node['jmh_webserver']['epic_maintenance_windows']

# Profile Proxies
default['cq']['app_proxies']['profile_proxies']['id'] = 'profile_proxies'
default['cq']['app_proxies']['profile_proxies']['target_recipe'] = 'jmh-myjmh\\:\\:profile-client'
default['cq']['app_proxies']['profile_proxies']['port'] = 8466
default['cq']['app_proxies']['profile_proxies']['proto'] = 'https'
default['cq']['app_proxies']['profile_proxies']['proxies'] = {'/profile-client' => '/profile-client'  }
default['cq']['app_proxies']['profile_proxies']['maintenance'] = false
default['cq']['app_proxies']['profile_proxies']['maintenance_page'] = '/jmherror/myjmh_maintenance.html'
default['cq']['app_proxies']['profile_proxies']['maintenance_windows'] = node['jmh_webserver']['epic_maintenance_windows']

# Event Proxies
default['cq']['app_proxies']['event_proxies']['id'] =  'event_proxies'
default['cq']['app_proxies']['event_proxies']['target_recipe'] = "jmh-events\\:\\:client OR recipes:jmh-apps\\:\\:events"
default['cq']['app_proxies']['event_proxies']['port'] =  8443
default['cq']['app_proxies']['event_proxies']['proto'] =  'https'
default['cq']['app_proxies']['event_proxies']['proxies'] =  { '/events' => '/events'}

# FAD Proxies
default['cq']['app_proxies']['fad_proxies']['id'] =  'fad_proxies'
default['cq']['app_proxies']['fad_proxies']['target_recipe'] = 'jmh-fad\\:\\:client'
default['cq']['app_proxies']['fad_proxies']['port'] =  8085
default['cq']['app_proxies']['fad_proxies']['proto'] =  'http'
default['cq']['app_proxies']['fad_proxies']['proxies'] =  { '/fad' => '/fad' }
default['cq']['app_proxies']['fad_proxies']['maintenance'] = false

# Preregistration
default['cq']['app_proxies']['prereg_proxies']['id'] =  'prereg_proxies'
default['cq']['app_proxies']['prereg_proxies']['target_recipe'] =  'jmh-prereg\\:\\:client'
default['cq']['app_proxies']['prereg_proxies']['port'] =  8444
default['cq']['app_proxies']['prereg_proxies']['proto'] =  'https'
default['cq']['app_proxies']['prereg_proxies']['proxies'] =  { '/preregistration' => '/preregistration'}

# Custom proxies
default['cq']['app_proxies']['subsite_proxies']['id'] = 'subsite_proxies'
default['cq']['app_proxies']['subsite_proxies']['target_role'] = 'php_subsites'
default['cq']['app_proxies']['subsite_proxies']['port'] = 82
default['cq']['app_proxies']['subsite_proxies']['proxies'] = {
    '/mdstart' => '/mdstart'
}
