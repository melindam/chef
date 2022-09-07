default['jmh_server']['chef']['log_level'] = 'info'
default['jmh_server']['chef']['version'] = '15.10.12'

default['chef_client']['server_url'] = "https://api.opscode.com/organizations/jmhebiz"
default['chef_client']['validation_client_name'] = "jmhebiz-validator"
default['chef_client']['chef_license'] = "accept"
default['chef_client']['cron']['use_cron_d'] = false

default['authorization']['sudo']['inclucde_sudoers_d'] = true

default['jmh_server']['admin']['email'] = ['melinda.moran@johnmuirhealth.com']

default['jmh_server']['root']['bindir'] = '/root/bin'
default['jmh_server']['root']['user'] = 'root'
default['jmh_server']['root']['group'] = 'root'

default['jmh_server']['use_chef_cron'] = true

default['jmh_server']['secret']['upgrade_secret'] = false
default['jmh_server']['secret']['chef_file'] = '/etc/chef/encrypted_data_bag_secret'
# Need to update the user & password before the run
default['jmh_server']['secret']['uri'] = '<user>:<password>@ebizrepo.johnmuirhealth.com/download/secret.txt'
default['jmh_server']['secret']['credentials_databag'] = ['jmh-archiva','app_download']
default['jmh_server']['secret']['databag_userhash_key'] = 'user'
default['jmh_server']['secret']['databag_passwordhash_key'] = 'passwd'

default['jmh_server']['backup']['authorized_keys'] =
      [ { "databag": "credentials",
          "databag_item": "rundeck",
          "record": "public_key",
          "encrypted": true
          },
          { "databag": "credentials",
          "databag_item": "awstats",
          "record": "ssh_public_key",
          "encrypted": true
          },
          { "databag": "credentials",
          "databag_item": "bamboo",
          "record": "ssh_public_key",
          "encrypted": true
          },
          { "databag": "credentials",
          "databag_item": "jmhbackup",
          "record": "ssh_public_key",
          "encrypted": true
          }]
default['jmh_server']['backup']['username'] = 'jmhbackup'
default['jmh_server']['backup']['group'] = 'jmhbackup'
default['jmh_server']['backup']['home'] = '/home/jmhbackup'
default['jmh_server']['users']['password_expire_days'] = 99999

default['jmh_server']['sudo']['passwordless'] = true
default['jmh_server']['sudo']['groups'] =  case node['jmh_server']['environment']
when 'prod', 'stage'
    ["wheel", "sysadmin"]
  else
    ["wheel", "sysadmin", "devadmin", "devcontractor"]
  end
default['jmh_server']['environment'] = '_default_'


# Postfix Mail Server info
# arstage env has set ['postfix']['main']['relayhost'] = "localhost" so NO emails go out - Oct 2021
default['postfix']['relayhost_role'] = 'mail_server'
default['jmh_server']['use_mail_relay'] = false
default['jmh_server']['mail']['mail_relay'] = '172.23.201.58'
default['jmh_server']['mail']['inet_all'] = 'all'
default['jmh_server']['mail']['load_balancer_data_bag'] = ['credentials','brocade']

# SSH
default['jmh_server']['ssh']['sshd_config']['client_alive_interval'] = 300
default['jmh_server']['ssh']['sshd_config']['client_alive_count_max'] = 6
default['jmh_server']['ssh']['sshd_config']['permit_root_login'] = 'no'

default['tz'] = "America/Los_Angeles"
default['yum']['main']['tsflags'] = 'repackage'

default['ntp']['servers'] = ["0.us.pool.ntp.org", "1.us.pool.ntp.org", "2.us.pool.ntp.org", "3.us.pool.ntp.org"]

default['postfix']['use_relay_restrictions_maps'] = false
default['postfix']['main']['smtpd_relay_restrictions'] = [ "permit_mynetworks", "permit_sasl_authenticated", "defer_unauth_destination"]
