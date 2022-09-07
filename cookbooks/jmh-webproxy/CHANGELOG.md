jmh-webproxy Change Log
========================

0.2.25
- renamed supportportal logs for ease of readability when on apache with multi configs

0.2.24
------
- updated directories Rewrite rules for vv 

0.2.23
------
- added new /vv vvisits-client proxy and rewrite rule

0.2.22
--------
- updated `supportportal.rb` to use local resources for webcommon and app_widgets when necessary

0.2.21
------ 
- added `/createvisit` redirect

0.2.20
------
- added webcommon to `supportportal.rb`

0.2.19
------
- added videovisit to `supportportal.rb`

0.2.18
------
- removed context for billpay-admin from supportportal proxies

0.2.17
-------
- Updated sensu uchiwa proxy to be https
- removed mobstage: `['jmh_webproxy']['tools']['apistage']`

0.2.16
------
- Remove everything but sensu

0.2.15
-----
- Removed mob sites 
- Removed port 80
- added dev2 sites

0.2.14
------
- updates for webserver names to be used from new standard jmh-server attributes

0.2.13
------
- Adding zodoc and cleaning up all ip's not associated with a business

0.2.12
------
- updating apache2 variables to jmh-webserver variables

# 0.2.11
--------
- update to arprod
- added herodigital_ips variable to shorten the list

# 0.2.10
--------
- update to arprod
- added jmh_ips variable to shorten the list

# 0.2.9
-------
- Adding idp-sbx and idp-dev johnmuirhealth.com proxy

# 0.2.8
-------
- Added Apache 2.4 intelligence

# 0.2.7
-------
- Added tools proxy

# 0.2.6
------
- Support for multiple certs

# 0.2.5
-------
- support for Apache 2.4

# 0.2.4
-------
- Create alias list functionality cause I was tired of all the server alias repetitions

# 0.2.3
-------
- updated Zipnosis training IP address for access to www-sbx and www-dev
- added jmh-prereg as a dependency and removed jmh-apps

# 0.2.2
-------
- update recipe search for myjmh-admin to myjmh cookbook
- added api to webproxy

# 0.2.1
-------
- include http to https redirect when accessing PRC sites
- adding 50.171.254.132 for Zipnosis office to HTTPS dev site

# 0.2.0
--------
- Added aws proxy

# 0.1.0
-------
- Added `support-portal`