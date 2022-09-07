default['jmh_billpay']['scripts_dir'] = '/usr/local/webapps/billpay/scripts'
default['jmh_billpay']['scripts'] = %w(billpay_execute_transfer.sh billpay_export_email_legacy.sh billpay_export_epic.sh billpay_import_export_archive.sh)

default['jmh_billpay']['ftp_server']['user'] = 'billpay-ftp'
default['jmh_billpay']['ftp_server']['group'] = 'billpay-ftp'
#default['jmh_billpay']['ftp_server']['password'] = '$1$HKa2bUkb$2nIYNLPd0.5IFlWeOlAS70' #billpay
default['jmh_billpay']['ftp_server']['password'] = '$6$OM40TKMF$6.Jn8YjSLBX0Hz0IKJGrMN2akjg7Mpxxs85deUnFLVdp2CkTzem.r2GqY.c7dze0cYliXE82yMEc9Xq1EvyZc1' #billpay

#default['jmh_billpay']['ftp']['server'] = '172.23.103.225'
#default['jmh_billpay']['ftp']['username'] = 'eBusiness'
#default['jmh_billpay']['ftp']['password'] = 'Ebusftp5$'
#default['jmh_billpay']['ftp']['ext'] = 'txt'
#default['jmh_billpay']['ftp']['destdir']['import'] = ''
#default['jmh_billpay']['ftp']['source']['import'] = ''

# For legacy export files
default['jmh_billpay']['export']['destdir'] = 'input'
default['jmh_billpay']['export']['source'] = '/usr/local/webapps/billpay/export'
default['jmh_billpay']['export']['email']['legacy_files'] = 'cindy.chen@johnmuirhealth.com,webinquiries@johnmuirhealth.com'

default['jmh_billpay']['transfer']['addresses'] = ['melinda.moran@johnmuirhealth.com']
default['jmh_billpay']['transfer']['bindir'] = '/usr/local/webapps/billpay/scripts'
default['jmh_billpay']['transfer']['logfile'] = 'billpayTransfer.log'
default['jmh_billpay']['transfer']['epiclogfile'] = "epic_transfer.log"
default['jmh_billpay']['transfer']['email'] = false

default['jmh_billpay']['epic']['server'] = "206.107.211.51"
default['jmh_billpay']['epic']['user'] = "ebusiness"
default['jmh_billpay']['epic']['destdir'] = "/ebusiness/production"
default['jmh_billpay']['epic']['identity_file'] = "/home/tomcat/.ssh/ebusiness_id_rsa"
default['jmh_billpay']['epic']['host_key'] = 'AAAAB3NzaC1kc3MAAACBAKkGrlBrWZPl9UCEp6n9BRc6W7NfPyHUGf4IFYCalq/KizYJXudFSuaZO/TSG6S6XfOWclZ1m2VY8LGUQVaWWHaHOh5u447MnyY0LGZ6+7WJxgk2ei+RKYN60YRxuXzAlt8JdXrsFz32nPa6sBvNJoyA6arX+XYnkST5FiZoAn1xAAAAFQCUrd5IKRzbTm3De96mlqKuf8wXUQAAAIAQGFQUgAjDlkfd/4mjZscaF7gX6XpdKSGdWsieUCTeSr+i7Shp2QEJfzY4nfcVD0BBgiLrt1eTyvpDiY0MwBDyYSRTyDYuxvZxl86Ku0YUpwwV6TJN2S1QIkmOjWRUWnuD4N9LymLWc0C3NitfHpr6w1CdpWEL17gIYShzVZ9gNQAAAIBfQb6xnNYFnPZdOBK314JT0fX2veBzOzrSr/mxe/Ny2z/l6whBbrsLRG0pdufwq6aO/PvEjPhyAioTPxwKj/nwliJZXBRAMNVC3NTbNXchHPxsCL6m2FEcG/383iD6kY9UR3dwYlmq7s6xOzmClkIaDRv76KeXPpIZpsgxGP4qoA=='
default['jmh_billpay']['epic']['key_type'] = 'ssh-dss'
