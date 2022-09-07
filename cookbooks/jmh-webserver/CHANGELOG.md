# 0.5

## 0.5.44

- changed apach logrotate to 2 years for prod, else 4 weeks

## 0.5.43

- changed context for /pg to be "blank"

## 0.5.42

- added Tealium web variables

## 0.5.41

- added newrelic global variable to api-config.js

## 0.5.40

- added new directives (`['jmh_webserver']['mychart']['proxy_directives']`)  to handle IIS in recipe `mychart_proxy.rb`
- added new directives to handle IIS in `api_proxies.rb`
- changed logrotate for httpd to be 4 instead of 12 as prod logging increased

## 0.5.39

- added payment-gateway /pg to api server

## 0.5.38

- update `customphonebook.rb` to use idp for username recovery

## 0.5.37

- update Content-Security-Policy for www.johnmuirhealth.com and made it *.johnmuirhealth.com

## 0.5.36

- updates to api to exlude path from front end of vvisits sendReminders

## 0.5.35

- update to `web_app.conf.erb` to allow for chunked data for proxy request (https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#request-bodies) 
- added `ProxyTimeout` to be setting that can be changed

## 0.5.34

- added vvisits-client code base recipe and deployment scripts

## 0.5.33

- included new api proxy for video visits
- included new webcommon api_config for vvisits path and google analytics key for vvisits
- included new api-config.js value `JMH_videoVisitsClientBaseUrl`

## 0.5.32

- added emp_token to header_access_control on `web_app.conf.erb`
- added jiveon.com to `['jmh_webserver']['sso']['frame_ancestors']`
- added deploy_video.sh for app_widgets deploy

## 0.5.31

- removed oidc from webserver - a lot of deletes
- remove `myjmh.rb` recipe

## 0.5.30

- Updated various web servers to use global variables for server aliases.

## 0.5.29

- Removed myjmh website references.

## 0.5.28

- added jmherror proxy removal for idp

## 0.5.27

- added another argument to the end of the `oidc_error_template.html.erb`

## 0.5.26

- removes mychart tiles instances
- excluded prerender.io string of /npi to REQUEST_URI
- new property for numschedulingdays
- oidc_error_template.html.erb updates
- included new api-config.js value `googleMapsApiKeyForUrgentCareAndDocScheduler`

## 0.5.25

- updated `['jmh_webserver']['idp']['https']['cond_rewrites']` to handle the old myjmh-client redirects
- added custom_config ability to `proxies.conf.erb`

## 0.5.24

- Updated `['jmh_webserver']['apache']['remote_ip_proxy_servers']` to be updated in `default.rb` from the data bag `credentials/brocade`
- Added `['jmh_webserver']['apache']['vpn_ips']` for the vpn ip's (proxies for aws)

## 0.5.23

- include Google BOTS User agent to foward to prerender.io for /doctor
- removed references to tcell and variables and recipe

## 0.5.22

- Make JMHHR a webserver with some redirects and not a php site ( `jmhhr.rb`)

## 0.5.21

- remove php references from `failover_site.rb`
- remove attribute `['jmh_webserver']['jmhhr']['enable_rewrites']`

## 0.5.20

- Added full redirect for johnmuirhr.com
- Updated recipe `webcommon.rb` and template `web_app.conf.erb` to use the property `['jmh_webserver']['test_run']['port']`

## 0.5.19

- Removed apptapi from `api_proxies.rb` git

## 0.5.18

- added `customphonebook.rb`. Moved from `jmh-cq`
- added new values for webcommon `api-config.js`

## 0.5.17

- moved Header calls from `auth_openidc.conf.erb` to `web_app.conf.erb`
- added `['jmh_webserver']['sso']['mychart_frame_ancestors']`
  - mychart calls will have a different frame ancestors
- updated `remoteip.conf.erb` to take RequestHeader from `['jmh_webserver']['apache']['remote_ip_header']`
- added expires for application/font-sfnt
- updates to `oidc_error_template.html.erb`

## 0.5.16

- updated `auth_openidc.conf.erb`
  - get its frame ancestors from the property `['jmh_webserver']['sso']['frame_ancestors']`

## 0.5.15

- redirects for login/logout pages for hr

## 0.5.14

- included google API key in webcommon config
- included google analytics ID in webcommon config

## 0.5.13

- removed from `php-common` from `['php']['remove_packages']`

## 0.5.12

- Added sso mychart to `mychart_proxy.rb`

## 0.5.11

- Added shareeverywhere.epic.com to frame-ancestors in `auth_openidc.conf.erb`
- included the removal of extra php packages
- included google maps API key in webcommon config

## 0.5.10

- Added CORS header control to idp

## 0.5.9

- Removed tcell info
- remove "/etc/httpd" and replaced with `['apache']['dir]`
- updated mychart proxy logs to go to encrypted partition

## 0.5.8

- Added property to google_captcha_site_key `api-config.js.erb`

## 0.5.7

- ?

## 0.5.6

- Added property to `api-config.js.erb`
- Added copy to the webcommon dir, in case we need to update between releases.

## 0.5.5/6

- final go live info for openidc
- removed `oidc_error_template.html.erb` from `idp.rb` since it is in `jmherror.rb`

## 0.5.4

- more updates to `auth_openidc.conf.erb`
- moved location of the oidc_error_template.html to the jmherror folder

## 0.5.3

- Added "root_location" parameter to the `web_app.conf.erb`
- Added new header values for openidc authentication
- Removed `['jmh_webserver']['api']['app_proxies']['api']`

## 0.5.2

- `proxies.conf.erb` fix for maintenance windows rewrites
- flag for openidc change for myjmh

## 0.5.1

- Added openidc for myjmh login

## 0.5.0

- api config to include header for CORS
- removed references to REGAPP recipe and attributes, and cleaned up databag

# 0.4

## 0.4.22

- added template for api-config URLs for webcommon project

## 0.4.21

- Removal of `OIDCProviderEndSessionEndpoint` from auth_openidc.conf.erb

## 0.4.20

- include HTML template for openidc error messages to myjmh
- update AllowOverride all as a default to none
- Added camel case to mychart

## 0.4.19

- allowed for `target_ipaddress` for an app_proxy of api

## 0.4.18

- upgrade to openidc to 2.3.8 (https://github.com/zmartzone/mod_auth_openidc/issues/331)
- added `profile-api/docs` block to api front end

## 0.4.17

- Added ability to block proxy in `proxies.conf.erb`

## 0.4.16

- Added profile-api to api

## 0.4.15

- Added LimitRequestFieldSize
- Added OpenIDC OIDCStateTimeout in apache module config
- changed names of the mychart_proxy logs

## 0.4.14

- Added MyChart Mobile's own MyChart Context

## 0.4.13

- included CORS header (Access-Control-Allow-Origin) for /scheduling API proxy

## 0.4.12

- upgrade of openidc to allow for relative uri
- added scheduling to api
- deprecated regapp

## 0.4.11

- adding more customization to proxies template

## 0.4.9

- openidc authorization module
- updated proxies.conf.erb to all for directives to be passed properly
- removed legacy apache code from the proxies.conf.erb

## 0.4.8

- opened up mychart proxy

## 0.4.7

- updates for webserver names to be used from new standard jmh-server attributes

## 0.4.6

- removed TLSv1 from RHEL 7 installs
- added tcell to be enabled
- added warning that mychart_proxy cannot run on same server as dispatcher

## 0.4.5

- updated maintenance windows to not be environment specific: set it in the environment and it only runs on that environment. 

## 0.4.4

- moving more apache2 through jmh-webserver

## 0.4.3

- fixes to get ready for Chef 13

## 0.4.2 

- Force redirect of /webrequest to Service Now full URL

## 0.4.1 

- New service now URL

## 0.4.0

- update php to 7.1

# 0.3

## 0.3.12

- customized expires template

## 0.3.11

- adding security for mychart_proxy
- adding fonts and fixes to jmherror

## 0.3.10

- Adding rewrite condition for idp proxy

## 0.3.9

- Adding mychart_proxy

## 0.3.8

- updates to bitbucket known_hosts file so that it actually works

## 0.3.7

- created fail_over site recipe
- remove apache_ports cookbook since it is only used by php sites, so I moved it php_site.rb.
- in jmherror pages, removed all webcommon references because this site needs to work when webcommon is down.

## 0.3.6

- added idp pingfed proxy web server

## 0.3.5

- script updates for HTML apps for CentOS 7 permissions change
- new logo added for rebranding Aug 2017

## 0.3.4

- remote ip update to make it easier to update the proxies

## 0.3.3

- Added apache 2.4 intelligence

## 0.3.2

- including dev-resources web site on ebiz23 
- including regapp web server recipe

## 0.3.1

- Added new error pages for new JMH site

## 0.3.0

- move app proxies for api for a variable instead of a databag

# 0.2

## 0.2.18

- Added error/maintenance page
- split out jmherror attributes

## 0.2.17

- changing way to include IE11 compatibility view problems to local param instead of node variable

## 0.2.16

- migrated loaderwidget to app_widget/loader and app_widget/scheduling for JMH website redesign

## 0.2.15

- added loaderwidget
- included front end access to api.johnmuirhealth.com  (e.g. myjmh-services)
- included HTTP Header for IE11 compatibility mode for JMH internal IE issues

## 0.2.14

- removed openscheduling-widget apache setup

## 0.2.13

- added apache Header Access-Control methods to .conf files

## 0.2.12

- logrotate_app requires logrotate cookbook, using default options Array values
- depends on logrotate

## 0.2.11

- initial support for Apache 2.4

## 0.2.10

- move Epic OpenScheduling URL to use environment data bag
- created opensched maintenance window template

## 0.2.9

- Including opensched apache proxy to point to EPIC MyChart OpenScheduling URL

## 0.2.8

- Added new api webserver
- Added new remote ip

## 0.2.7

- [scottymarshall](https://github.com/scottymarshall)  - Added md redirect

## 0.2.6

- [melindam](https://github.com/melindam) - used node search to find web servers for php_rollout scripts

## 0.2.5

- [scottymarshall](https://github.com/scottymarshall) - upgrade to php 56

## 0.2.4

- [scottmarshall](https://github.com/scottymarshall) - getting rid of references to jmh-apps

## 0.2.3

- [scottymarshall](https://github.com/scottymarshall) - Set RHEL 5 to only TLSv1

## 0.2.2

- [scottymarshall](https://github.com/scottymarshall) - SSL Protocol to only TLS

## 0.2.0

- [scottymarshall](https://github.com/scottymarshall) - Added apache webserver code

# 0.1

## 0.1.0

- [scottymarshall](https://github.com/scottymarshall) - Initial release of jmh-webserver

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.