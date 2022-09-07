default['jmh_tomcat']['rollout_script']['legacy_hash'] =
  { 'default' => [{ 'bamboo_name' => 'default', 'war_name' => 'default' }],
    'events' => [{ 'bamboo_name' => 'events-admin', 'war_name' => 'events', 'db_name' => 'events' }],
    'preregistration' => [{ 'bamboo_name' => 'pre-registration-consumer', 'war_name' => 'preregistration', 'db_name' => 'preregistration' }],
    'prereg-admin' => [{ 'bamboo_name' => 'pre-registration-admin', 'war_name' => 'prereg-admin' }],
    'webrequest' => [{ 'bamboo_name' => 'webrequest', 'war_name' => 'webrequest' }],
    'billpay-admin' => [{ 'bamboo_name' => 'billpay-admin', 'war_name' => 'billpay-admin' }],
    'billpay' => [{ 'bamboo_name' => 'billpay-services', 'war_name' => 'billpay-services' },
                  { 'bamboo_name' => 'billpay', 'war_name' => 'billpay', 'db_name' => 'billpay' }],
    'profile' => [{ 'bamboo_name' => 'profile-client', 'war_name' => 'profile-client', 'db_name' => 'profile' }],
    'myjmh-admin' => [{ 'bamboo_name' => 'myjmh-admin', 'war_name' => 'myjmh-admin' }],
    'api' => [{ 'bamboo_name' => 'myjmh-services', 'war_name' => 'api' }],
    'broker' => [{ 'bamboo_name' => 'broker', 'war_name' => 'broker', 'db_name' => 'broker' }],
    'apptapi' => [{ 'bamboo_name' => 'apptapi', 'war_name' => 'apptapi' }]
  }
