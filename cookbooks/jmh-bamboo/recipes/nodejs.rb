# Installs nodejs

template File.join('home', node['jmh_bamboo']['run_as'], '.npmrc') do
  source 'npmrc.erb'
  owner node['jmh_bamboo']['run_as']
  group node['jmh_bamboo']['run_as']
  mode 0600
  variables(
      :npm_private_token => node['jmh_bamboo']['npm_private_token']
  )
end

node['jmh_bamboo']['nodejs_versions'].each do |nodejs_version|
  jmh_nodejs_install "Bamboo install for node version #{nodejs_version}" do
    version nodejs_version
    action :install
  end
end