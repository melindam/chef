CHANGELOG
=========

# 0.6

## 0.6.0

- new `pf.plugins.pf-pcv-rest.jar`

# 0.5

## 0.5.9

- updated html.form.login.template.covid19.content.url in messages_en.properties

## 0.5.8

- upgraded licenses
- removal of 9.x licenses and demo licenses

## 0.5.7

- new `pf.plugins.pf-pcv-rest.jar`

## 0.5.6

- change license to go with version of pingfederate
- added 10.1 licenses
- upgrade to 10.1

## 0.5.5

- added values for covid19 to pingfederate-messages_en.properties file

## 0.5.4

- added values for tealium to pingfederate-messages_en.properties file

## 0.5.3

- new plugin for `pf.plugin.set-cookie-authentication-selector.jar`

## 0.5.2

- moved plugin cookbook_file to a resource `jmh_pingfed_install_plugins`
- added a new plugin, `pf.plugins.mfa-authentication-selector.jar`.
- renamed `pf.plugins.set-cookie-authentication-selector.jar` by removing the 's' from plugins (so it could be put in a cookbook file array)
- Added more properties to the `pingfederate-messages_en.properties.erb`

## 0.5.1

- Added sameSiteExcludedUserAgentPatterns to `jetty-runtime_xml.erb`
- Added rsync package to the `common.rb` recipe

## 0.5.0

- upgrade to Pingfed 9.3.2, licenses and all
- copied a few properties from pingfed cookbook to allow us to upgrade version without having to update pingfed cookbook
  - `['pingfed']['version]`
  - `['pingfed']['filename']`
  - `['pingfed']['download_url']`

## 0.4.2

- added new property for remind me toggle button

## 0.4.1

- added pingfed-messages new property for api-host

## 0.4.0

- added `common.rb` and `pingfederate-console.rb`

## 0.3.0

- Pingfederate 9.2 for development and production


## 0.2.7

- updates to `auth_policies_default.erb`

## 0.2.6
-
- node.set changed to node.normal
- secure_password changed to random_password

## 0.2.5

- get basic auth from a data bag: jmh_apps/profile-api

## 0.2.4

- update RESTCROWD authentication to use basic auth for new /profile-api calls

## 0.2.3

- included file for pingfed overrides as <PF_SERVER>/server/default/conf/language-packs/pingfederate-messages_en.properties

## 0.2.2

- updated variable calls for websites to globals
- consolidate calls for secret keys for pingfed
- removed dependency on jmh-myjmh and moved to jmh-epic

## 0.2.1

- Moved secure password and client secret keys into databag
- Fixed PUT syntax for oauth_auth_server_settings

## 0.2.## 0

- add automatic configuration for oauth config, clients and server settings

## 0.1.1

- add plugin for set-cookie-authentication-selector

## 0.1.0

- pingfederate config
- licenses added and will expire 2020-08-30
