# jmh-pingfed


Attributes
==========

* `node['jmh_pingfed']['server_hostname']` = FQDN of server for API calls
* `node['jmh_pingfed']['admin_user']` = 'Administrator'
* `node['jmh_pingfed']['admin_password']` = 'Some Password you manually set'
* `node['jmh_pingfed']['execute_do_not_show_sensitive_data']` = true,false depending if need to see output from execute commands


Recipes
=======

### default 

Installs `standalone` version of pingfederate

### standalone

Installs `standalone` version of pingfederate

### oauth_settings

Configures specific JMH server configuration for JMH, WELLBE and FHIR (mychart)

* NOTE - this recipe is no longer used in JMH cookbook, but left for reference.
* FIRST time this cookbook is run it will not create the configuration as Pingfederate requires
  manual intervention to create a user and password and set some default install parameters
* SECOND time this cookbook runs, it will create all the configuration and can
   be validated via https://<server_name>:9999/pf-admin-api/api-docs/
