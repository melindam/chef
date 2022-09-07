name "aws_proxy"
description "awsproxy"

run_list([
  "role[base]",
  "recipe[jmh-webproxy::aws_proxy]"
])

override_attributes( 
  'jmh_server' => {
    'use_mail_relay' => false
  },
  'sensu' => {
    'rabbitmq' => {
        'host' => 'ec2-54-215-186-166.us-west-1.compute.amazonaws.com'
    }
  },
  'postfix' => {
      'main' => {
          'relayhost' => 'ec2-54-215-142-73.us-west-1.compute.amazonaws.com'
      }
  }
)

