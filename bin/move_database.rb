#!/usr/bin/env ruby
require 'chef-api'
# https://github.com/chef/chef-api
require 'highline/import'
require 'optparse'
require 'time'

current_dir = Dir.pwd
repo_index = Dir.pwd.index('chef-repo')
chef_repo = File.join(current_dir[0,repo_index], 'chef-repo')
Dir.chdir chef_repo

options = {}
#defaults
# options['source_name'] = 'apps02-sbx'
# options['dest_name'] = 'apps02-tst2'
# options['database'] = 'profile'

options['user'] = `echo $USER`.chomp!
options['local_dir'] = options['user'] == 'smarshal' ? '/Users/smarshal/Desktop/nobackup' : nil
options['stop_source_tomcat'] = false

OptionParser.new do |opts|
  opts.banner = "Usage: move_database.rb [options]"
  opts.on('-n', '--db ', 'Database Name') { |v| options['database'] = v }
  opts.on('-u', '--username', 'SSH Username') { |v| options['user'] = v }
  opts.on('-s', '--source', 'Source Server') { |v| options['source_name'] = v }
  opts.on('-d', '--destination', 'Destination Server') { |v| options['dest_name'] = v }
  opts.on('-t', '--tomcat', 'Tomcat Instance') { |v| options['tomcat'] = v }
  opts.on('-a', '--appshutdown', 'Shutdown Source Tomcat Instance') { |v| options['stop_source_tomcat'] = v }
  opts.on('-l', '--localdir', 'Local Tmp Directory') { |v| options['local_dir'] = v }
  opts.on('-h', '--help', 'Help') { puts opts
                                    exit }
end.parse!

username = options['user'] == 'smarshal' ? 'scott' : options['user']
username = ask "What is the ssh user?: " if username.nil?
db = options['database']
db = ask "What is the database name?: " if  db.nil?
options['source_name'] = ask "What is the source server? (Type 'local' if db already local): " if  options['source_name'].nil?
options['dest_name'] = ask "What is the destination server? (Type 'localhost' if db on vagrant): " if options['dest_name'].nil?
options['tomcat'] = ask "What is the name of the app to restart?: (Type 'none' if no restart) " if  options['tomcat'].nil?
options['local_dir'] = ask "What is your local temp directory?: " if  options['local_dir'].nil?


puts "Username: #{username}"
puts "Database: #{db}"
puts "Source Server: #{options['source_name']}"
puts "Destination Server: #{options['dest_name']}"
puts "App Instance: #{options['tomcat']}"
puts "Shutdown Source App Instance: #{options['stop_source_tomcat']}"
puts "Local Temp Directory: #{options['local_dir']}"

proceed = ask "Is this correct? [y/n]: "

if proceed != 'y'
  puts "Stopping script"
  exit
end

time_begin = Time.new

source_ip = nil
dest_ip = nil
source_password = nil
dest_password = nil
local = false
dest_port = options['dest_name'] == 'localhost' ? '2222' : '22'

connection = ChefAPI::Connection.new(
    endpoint: 'https://api.opscode.com/organizations/jmhebiz',
    client:   ENV['OPSCODE_USER'],
    key:      "~/.chef/#{ENV['OPSCODE_USER']}.pem"
)

if options['source_name'] == 'local'
 local = true
 source_ip = 'localhost'
else
  x = connection.nodes.fetch("#{options['source_name']}").to_hash
  source_password = x[:normal]['mysql']['server_root_password']
  source_ip = case
              when x[:automatic]['cloud']
                x[:automatic]['cloud']['public_hostname']
              else
                x[:automatic]['ipaddress']
              end
  puts "The source ip: #{source_ip}"
end

if options['dest_name'] == 'localhost'
  dest_ip = '127.0.0.1'
  dest_password = 'password'
else
  x = connection.nodes.fetch("#{options['dest_name']}").to_hash
  dest_password = x[:normal]['mysql']['server_root_password']
  dest_ip = case
            when x[:automatic]['cloud']
              x[:automatic]['cloud']['public_hostname']
            else
              x[:automatic]['ipaddress']
            end
  puts "The dest ip: #{dest_ip}"
end

if dest_ip.nil? || source_ip.nil?
  puts "**Fail** Could not find all servers"
  exit
end

unless local
  if options['stop_source_tomcat']
    puts "Now Stopping Old System"
    %x(ssh #{username}@#{source_ip} "sudo /usr/sbin/service #{options['tomcat']} stop")
  end

  puts "Creating SQL Dump of Source Database at: #{source_ip}"
  %x(ssh #{username}@#{source_ip} "sudo /usr/bin/mysqldump -u root --opt --databases #{db} --password=\"#{source_password}\" > /tmp/#{db}.sql; gzip /tmp/#{db}.sql;")
  puts "Copy to local system"
  %x(scp #{username}@#{source_ip}:/tmp/#{db}.sql.gz #{options['local_dir']})
  puts "Remove source dump"
  %x(ssh #{username}@#{source_ip} shred -u -z /tmp/#{db}.sql.gz)
end

puts "Copying to destination system at: #{dest_ip}"
puts "scp -P #{dest_port} #{options['local_dir']}/#{db}.sql.gz #{username}@#{dest_ip}:/tmp/"
%x(scp -P #{dest_port} #{options['local_dir']}/#{db}.sql.gz #{username}@#{dest_ip}:/tmp/)

unless local
  puts "Removing Local File"
  %x(rm -f #{options['local_dir']}/#{db}.sql.gz)
end
puts "Gunzipping"
%x(ssh -p #{dest_port} #{username}@#{dest_ip} gunzip -f /tmp/#{db}.sql.gz)

if options['tomcat'] == 'none'
  puts 'Skipping start'
else
  puts "Shutting Down #{options['tomcat']}"
  %x(ssh -p #{dest_port} #{username}@#{dest_ip} "sudo /usr/sbin/service #{options['tomcat']} stop")
end
puts "Importing Database"
%x(ssh -p #{dest_port} #{username}@#{dest_ip} "sudo /usr/bin/mysql -u root -p\"#{dest_password}\" < /tmp/#{db}.sql")

if options['tomcat'] == 'none'
  puts 'Skipping start'
else
  puts "Restarting #{options['tomcat']}"
  %x(ssh -p #{dest_port} #{username}@#{dest_ip} "sudo /usr/sbin/service #{options['tomcat']} start")
end

time_end = Time.new
puts "Process time: #{time_end - time_begin} seconds"
