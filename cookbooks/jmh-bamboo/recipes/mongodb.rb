
node.default['mongodb']['users'] = [
    {
        'username' => node['jmh_bamboo']['mongodb']['vvisit']['username'],
        'password' => node['jmh_bamboo']['mongodb']['vvisit']['password'],
        'roles' => %w( readWrite ),
        'database' => node['jmh_bamboo']['mongodb']['vvisit']['database']
    }
]

# TODO get sc:mongodb to work on install again in ebiz19
# include_recipe 'jmh-mongodb::default'
