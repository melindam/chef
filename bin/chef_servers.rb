#!/usr/bin/env ruby
require 'chef-api'
# https://github.com/chef/chef-api
require 'optparse'


current_dir = Dir.pwd
repo_index = Dir.pwd.index('chef-repo')
chef_repo = File.join(current_dir[0,repo_index], 'chef-repo')
Dir.chdir chef_repo

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: chef_servers.rb [options]"
  opts.on('-t', '--outputtype [dns,ssh]', 'Output Type') { |v| options['output_type'] = v }
  opts.on('-u', '--username [ssh username]', 'SSH Username') { |v| options['username'] = v }
  opts.on('-f', '--writetofile [file]', 'Write To File') { |v| options['write_to_file'] = v }
  opts.on('-h', '--help', 'Help') { puts opts
                                    exit }
end.parse!

outtype = ''
if options['output_type']
  outtype = options['output_type']
else
  input = ask "What is the output type [dns,ssh]?: "
  outtype = case
            when input == "dns"
              "dns"
            else
              "ssh"
            end
end

yourname = ''
if options['username']
  yourname = options['username']
elsif outtype == 'ssh'
  yourname = ask "What is your id?: "
end

new_file= ''
writetofile = 'n'
if options['write_to_file']
  writetofile = 'y'
  new_file = File.new("#{options['write_to_file']}", 'w')
end

connection = ChefAPI::Connection.new(
    endpoint: 'https://api.opscode.com/organizations/jmhebiz',
    client:   ENV['OPSCODE_USER'],
    key:      "~/.chef/#{ENV['OPSCODE_USER']}.pem"
)

nodelist = connection.search.query(:node, "name:*", {:sort => 'chef_id DESC'})
#puts nodelist.total
nodelist.rows.each do |n|
  thing = n['automatic']
  ipaddress = case
              when thing['cloud']
                outtype == 'ssh' ? thing['cloud']['public_hostname'] : thing['cloud']['public_ipv4']
              else
                thing['ipaddress']
              end
  if outtype == 'ssh'
    lineoutput = "alias #{n['name']}='ssh #{yourname}@#{ipaddress}'"
  else
    lineoutput =  "#{ipaddress}  #{n['name']} # #{thing['ipaddress']}"
  end

  if writetofile == 'y'
    new_file.puts lineoutput
  else
    puts lineoutput
  end
end
