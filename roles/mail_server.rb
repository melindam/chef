name 'mail_server'

description "Mail Server for a given environment"

run_list([
  "role[base]"
])  
