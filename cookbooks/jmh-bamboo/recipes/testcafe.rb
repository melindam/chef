# installs framwork for testcafe

include_recipe 'jmh-bamboo::nodejs'

package 'firefox'

node['jmh_bamboo']['nodejs_versions'].each do |npm_version|

  nodejs_path = JmhNodejsUtil.get_nodejs_home(npm_version, node)
  npm_cmd = File.join(nodejs_path, 'bin/npm')

  # now install testcafe from npm install command
  execute "Install test cafe version #{npm_version}" do
    command "#{npm_cmd} install -g testcafe testcafe-reporter-xunit"
    action :run
    not_if { ::File.exist?(File.join(nodejs_path, 'bin/testcafe')) }
  end
  # now install bower 
  execute "Install bower version #{npm_version}" do
    command "#{npm_cmd} install -g bower"
    action :run
    not_if { ::File.exist?(File.join(nodejs_path, 'bin/bower')) }
  end
  # now install typescript
  execute "Install typescript version #{npm_version}" do
    command "#{npm_cmd} install -g typescript"
    action :run
    not_if { ::File.exist?(File.join(nodejs_path, 'bin/typescript')) }
  end
  # now install mocha
  execute "Install mocha version #{npm_version}" do
    command "#{npm_cmd} install -g mocha"
    action :run
    not_if { ::File.exist?(File.join(nodejs_path, 'bin/mocha')) }
  end
end
