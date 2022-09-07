JMH-server Cookbook
==============================
Various recipes uses by the "base" role to setup a server to be an ebusiness server

Requirements
-------------


### Platform
* RHEL 6

### Cookbooks
* "yum"
* "users"
* "sudo"
* "iptables"
* "chef-client"
* "chef_handler"
* "postfix"
* "timezone-ii"

### Attributes
* `node['jmh_server']['chef']['log_level']` - level to run log level for chef-client
* `node[:jmh_server][:environment]` - used in many jmh cookbooks to define type of environment (i.e. _default, prod, stage, dev)
* `node[:jmh_server][:handlers][:hip_chat][:action]` - bugging hipchat is turned off by default, but turned on in environment files
* `node[:jmh_server][:use_mail_relay]` - set to false as a default, as it will not send mail out of the JMH mail relay server. Most environments are set to 'true', set to false on node if you want to not use JMH mail relay.  Most cq-publisher nodes are the relay servers.
* `node['jmh_server']['mail']['mail_relay']` - ip of mail relay
* `node[:tz]` - timezone variable.  Currently set to "America/Los_Angeles"
* `node['jmh_server']['global']['apache'][<<WEB_SERVER>>]['server_name']` = Default web server names for all cookbooks to utilize
* `node['jmh_server']['global']['google_api_key]'` = Global keys for AEM, FAD, Urgent Care maps

### Recipes
### chef_cron
Setup for chef to run as a cron job

### encrypted_data_bag
Setup to place encryption file in correct location for data bag decryption

### hipchat_handler
Hipchat as handler for chef.  When a chef client run breaks, a discussion board is notified

### iptables
Install general iptables rules for ebiz server

### jmh-yum
Used if you plan a using a local repo for yum

### jmhbackup
Standard helper user on all systems for file transfer and clean

### mail
Set up server to use a mail relay or just push out itself.  If you have a new server in the environmewnt, make sure run chef-client on the 
  mail_server to make sure your new server gets in.

### omnibus_updater
Used to update chef client when an update is planned.  If an update occurns, the local chef-client on the server and then fail the chef run.  You need to run it again manually

### ssh 
Install ssh

### timezone
Update the timezone-  `node[:tz]`

### users
Installs sysadmin and devadmin users on all boxes.  Access for devadmins changes depending on environment

### yum_epel_fix
The for epel was bad for a while and this recipe update epel key so yum does not throw errors

