 jmh-rundeck cookbook
==============================
Installs rundeck and apache proxy for myjmh

### Requirements
* 'rundeck', '>= 4.2.0'
* 'jmh-apps'
* 'jmh-db'
* 'openssl'

### Chef-Zero Requirements
* local chef-zero requires an empty directory data_bags/rundeck_projects for rundeck databag check

### Usage
execute default recipe 

### Attributes
`node[:jmh_rundeck][:hostname]` - host

`node[:jmh_rundeck][:projects]` - hash of projects for rundeck

# Recipes
* default - installs rundeck and apache server config
* options_web_server - localhost webserver used for json calls for rundeck

# Making new passwords
``digest: MD5:6e120743ad67abfbc385bc2bb754e29``

You can create an MD5 has on mac by doing the following
``echo -n '<password>' | md5``


# Author
Author:: Scott Marshall (scott.marshall@johnmuirhealth.com)

