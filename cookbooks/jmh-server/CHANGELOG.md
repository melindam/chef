jmh-server CHANGELOG
=======================

# 1.7

## 1.7.2

- included cleanup for /var/log/audit
## 1.7.1

- included LDAP authentication and new users to databag

## 1.7.0

- Removal of RHEL 5 and RHEL 7 only conditions (we are at RHEL 7 everywhere)
- updated code to allow for chef-client cookbook upgrade
- included new global attribute for tealium_reportsuite_id
- added new mychart servers to armor_servers IP tables template
- added new global variables for tealium

# 1.6
## 1.6.3

- removed chef_handler cookbook & `hipchat_handler.rb`.  Call is now in the code

## 1.6.2

- update to Chef 15.10.14
- added global attribute

## 1.6.1

- added license acceptance `['chef_client']['chef_license']`

## 1.6.0

- Updated `encrypted_data_bag.rb` to handle a new secret better

# 1.5
## 1.5.9

- Added windows hardening to the base
- Added os hardening to the base
- updated iptables template to jmh-server

## 1.5.8

- updated systemd description for chef_cron
- added defaults what what is in base rol
  - default['chef_client']['server_url'] = "https://api.opscode.com/organizations/jmhebiz"
    default['chef_client']['validation_client_name'] = "jmhebiz-validator"
    default['authorization']['sudo']['inclucde_sudoers_d'] = true

## 1.5.7

- Update `['jmh_server']['mail']['load_balancers']` to be populated by credentials/brocade databag

## 1.5.6

- Removal of bepatient code in `armor_server.erb`
- Allow ping to ebiz24 in `armor_server.erb`
- include global variable for google_api_key
- include global variables for patientportal

## 1.5.5

- added windows support to the `jmh-server::default`
- added global config for google_maps_api_key

## 1.5.4

- Upgrade to Chef 14
- include global variable for google_captcha_site_key

## 1.5.3

- hostnamectl update for centos on recipe `default.rb`
- removal of `firehost.rb`
- removal of `bepatient.rb`

## 1.5.2

- infosec splunk server change IP and name

## 1.5.1

- mail.rb changes to handle bad ip from a relay host server
- add pub02 in stage as a relay host
- update postfix cookbook to handle chef 13 issues

## 1.5.0

- updates for webserver names to be used from new standard jmh-server attributes. Added attributes file global.rb
- added pub02 in prod as a relay host
- commented out hipchat handler as it does not work

# 1.4
## 1.4.2

- removed recipe users::sysadmins to replace with resource users_manage for group sysadmin

## 1.4.1

- chef 13.8
- Chef 13.6 for RHEL 5 servers (last version that works with RHEL 5, 32bit)

## 1.4.0

- removed omnibus updater for chef_client_updater

## 1.3.3

- Removed 172.24.201.13 from the firewall
- Removed firehost from iptables
- Left in bepatient rules, so we have an example of allowing a vendor into our environment

## 1.3.2

- added chage to all active users

## 1.3.1

- Added sshd_config template
- Added chage to jmhbackup

## 1.3.0

- Added chef-client at boot
- Removed FTP access

## 1.2.1

- Added armor server
- Added update to /etc/hostname on rhel7
- Added JmhServerHelpers.rhel7?(node) to make it easier to ask if it is rhel 7

## 1.2.0

- upgrade of postmail cookbook

# 1.1

## 1.1.24

-- added BePaitent Users
-- removed old ebiz-tools02 from iptables

## 1.1.23

-- added ability to read encrypted bags for jmhbackup public keys

## 1.1.22

- chef-client new version for logrotate

## 1.1.21

- new hipchat handler code.

## 1.1.20

- added timezone support for RHEL 7

## 1.1.19

- Removed openssl_fix  - not needed anymore

## 1.1.18

- Updated encrypted data bag recipe.  See recipe for more information
- cleaned up firehost_server iptables config for new EPIC hosts and IPs

## 1.1.17

- Mail servers relay locked down to only servers in environment
- food critic and rubocop run

## 1.1.16

- Updates to firehost DMZ iptables for OpenScheduling apache proxy servers for stage and prod
- iptables update for port 161

## 1.1.15

- Updated mail relay ip

## 1.1.14

 - Updated mail relay to make it easier to update
 - Added other mail relay ips

## 1.1.13

Added devcontractor functionality to users.rb

## 1.1.12

Added a number of firehost ip's to the iptables FWR chain

## 1.1.11

Adding Firehost monitoring ip's

## 1.1.10

Openssl fix recipe for mysql problems.

## 1.1.9

Added new ip subnet for new servers

## 1.1.8

Added Cloverleaf to the firewall and an override to firehost node sets during a test run
