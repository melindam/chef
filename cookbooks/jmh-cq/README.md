# JMH-CQ

This cookbook provides support for installing CQ and creating
JMH based CQ instances.

## Important attributes
* `['cq']['aem_version']` - defines version of AEM, but also affects a number of attributes' values
* `['cq']['crypto_environment']` - defines which encryption files to use for the environment


## Important recipes

* `cq::author` - installs a CQ author instance
* `cq::publisher` - installs a CQ publisher instance
* `cq::dispatcher` - installs a CQ dispatcher
* `cq::scripts` - scripts used to download production packages and update various environments

## Bundles and assets

Bundles and assets can be downloaded from S3 and installed into
CQ instances. The list of assets and bundles to be installed
are defined for each instance separately (author and publisher).
Relevant node attributes for assets and bundles to install (using
author as an example):

* `node[:cq][:author][:bundles]` - Array of bundles to install (full S3 key)
* `node[:cq][:author][:assets]` - Array of assets to install (full S3 key)

## Dispatcher configuration

The CQ dispatcher uses a `dispatcher.any` configuration file to define
behavior and location of things like publish nodes. This configuration
is fully defined with the attribute:

* `node[:cq][:dispatcher][:any]`

It is a nested hash and can easily be updated via role override attributes
if required. Publisher nodes are auto-discovered and added to the hash
dynamically during the Chef run so as publishers are added or removed from
the environment, they will be detected on this dispatcher as well.

## Dispatcher SSL

SSL support is enabled by default. Attributes related to SSL:

* `node[:cq][:dispatcher][:ssl][:enabled]` - If ssl support is enabled or disabled
* `node[:cq][:dispatcher][:ssl][:data_bag]` - Name of data bag to retrieve item
* `node[:cq][:dispatcher][:ssl][:data_bag_item]` - Name of data bag item to retrieve (`id` field in data bag item)
* `node[:cq][:dispatcher][:ssl][:encrypted]` - If the data bag item is encrypted

## Extra configurations

The files within the attributes directory show all the attributes used within
this cookbook and can be updated via overrides to change the behavior of services
like CQ instances or configurations used for CQ instances / apache dispatcher.

* `node[:cq][:ldap_authentication]` - true if want to turn on AD login availability, set after initial system setup
* `node[:cq][:install_content]` - true if want to install content

## Maintenance Windows

Proxied applications are able to be put into a maintenance mode, ie. send to a maintenance page, depending on the data within their data bag.
Maintenance windows can be set on the fly using `['maintenance']` or scheduled using `['maintenance_windows']`.

Within the data bag for a proxy
* `['maintenance]` - Mash of chef environments and whether or not they should be in maintenance
i.e.
```
  "maintenance": {  "fhprod": false, "arstage" : false, "_default": false }
```
* `['maintenance_page']` - location of error page relative to root context
i.e. ``` "maintenance_page": "/jmherror/myjmh_maintenance.html" ```
* `['maintenance_windows']` - Mash of maintenance windows. (See table for fields)

| Window Field | Explanation |
|---------|-----------|
| Mash Key | Name of Window (Used for cross reference of other proxies down during same maintenance window) |
| `env` | Array of chef environments window is affecting |
|`start`| Start time of window in Date Format of **YY-MM-DD HH:MM:DD TMZ**|
|`stop`| Stop time of window in Date Format of **YY-MM-DD HH:MM:DD TMZ**|
 
## Apache Proxy and Load Balancer proxies

* `node['cq']['app_proxies'][<Proxy App Name>]['id']` - proxy of systems in apache for context
* `node['cq']['app_proxies'][<Proxy App Name>]['id']['target_recpie']` - e.g. `jmh-events\\:\\:client OR recipes:jmh-apps\\:\\:events`
* `node['cq']['app_proxies'][<Proxy App Name>]['target_ipaddress']` -  to set in the environment to override an IP address to use in a Load Balancer config 

# Backups 
Since zips need to shutdown the system, they need to be coordinated to not run at the same time.

> job day hour minute 
> author               Mon    19    16  
> author-nightly       *      17    16  
> publisher01-zip      Tue    19    16
> publisher01-nightly  *      17    16
> publisher02-zip      Wed    19    16
> publisher02-nightly  *      17    16
> publisher-zip        Fri    5     16
> publisher-nightly    *      17    16

The hour  is updated in the environment for prod and stage 
 