# jmh-nodejs

Installs nodejs version into /usr/local/nodeapp/<version>

Call the resource like this
```
jmh_nodejs_install "nodejs for #{node['jmh_application']['api']['name']}" do
  version node['jmh_application']['nodejs_version']
  action :install
end
```

