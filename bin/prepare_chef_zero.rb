#!/usr/bin/env ruby
require 'chef-api'
# https://github.com/chef/chef-api
require 'fileutils'
include ChefAPI::Resource

kitchen_environment = 'awspoc2'

chef_repo = Dir.pwd
if !File.exists?("#{chef_repo}/test")
  abort("Cannot find test folder in current directory.  Closing.")
end
Dir.chdir chef_repo

chef_roles=%w(base jmh-local jmh-local-no-awsvpn utilities jmh-archiva
    prereg-admin myjmh-admin jmh-crowd
		cq-dispatcher cq-publisher cq-author mail_server
		proxy_site splunk-client-new
		sensu-scott rundeck
		jmh-ebiz-crowd jmh-crowd subversion
		bamboo ebiz-tools ebiz23
		sensu-client-base ecryptfs fad-master
		webrequest events prereg-client fad apps07 pingfed
		web01 web01-rollout web01-tag jmhhr php_subsites php-rollout php-tag failover_site
                idev-jmhapp-web idev-comhub idev-sbo sensugo-aws
                idev-mdsuspension idev-jmhapp-web idev-jmpn)

chef_nodes=%w( ebiz23 monitor02-prd splunk-sbx apps02-tst
              publisher01-stg publisher01-prd publisher02-prd publisher-tst
              author-prd apps01-tst apps01-prd tools02-prd
              apps06-tst apps07-prd1 apps07-prd2 apps07-stg1 ebizdev1 ebizdev2 ebizdev3 apps08-prd1 apps08-prd2)

connection = ChefAPI::Connection.new(
    endpoint: 'https://api.opscode.com/organizations/jmhebiz',
    client:   ENV['OPSCODE_USER'],
    key:      "~/.chef/#{ENV['OPSCODE_USER']}.pem"
)

FileUtils.remove_dir 'test/nodes', true
FileUtils.remove_dir 'test/roles', true
FileUtils.mkdir_p 'test/nodes'
FileUtils.mkdir_p 'test/roles'

puts "*Adding Roles"
rolelist = connection.roles.list
rolelist.each do |r|
  if chef_roles.include?(r)
    r1 = connection.roles.fetch(r)
    unless File::exists?("./test/roles/#{r}.json")
      new_file = File.new("./test/roles/#{r}.json", 'w')
      new_file.puts r1.to_json
      puts "Adding role #{r}"
    else
      puts "Skipping role #{r}"
    end
  end
end

puts "*Adding Environment #{kitchen_environment} Nodes"
# Get Environment Nodes
nodeenvlist = connection.search.query(:node, "chef_environment:#{kitchen_environment}", )
nodeenvlist.rows.each do |n|
  unless File::exists?("./test/nodes/#{n['name']}.json")
    new_file = File.new("./test/nodes/#{n['name']}.json", 'w')
    new_file.puts n.to_json
    puts "Adding node #{n['name']}"
  else
    puts "Skipping node #{n['name']}"
  end
end

puts "*Adding Extra Nodes"
# Get Other Nodes
xtranodelist = connection.nodes.list
xtranodelist.each do |n|
  next unless chef_nodes.include?(n)
  xnode = connection.nodes.fetch(n).to_hash
  unless xnode[:automatic]['chef_environment'] == kitchen_environment
    unless File::exists?("./test/nodes/#{n}.json")
      new_file = File.new("./test/nodes/#{n}.json", 'w')
      new_file.puts xnode.to_json
      puts "Adding node #{n}"
    else
      puts "Skipping node #{n}"
    end
  end
end
