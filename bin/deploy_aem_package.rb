#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'optparse'
require 'net/http/post/multipart'


sleep_time = 30
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: deploy_aem_bundle.rb [options]"
  opts.on('-u', '--username [aem username]', 'AEM Username') { |v| options['username'] = v }
  opts.on('-p', '--password [pass]', 'AEM Password') { |v| options['password'] = v }
  opts.on('-i', '--host [hostnameport]', 'hostname and port') { |v| options['host'] = v }
  opts.on('-f', '--file [bundle_file]', 'Location of bundle file') { |v| options['file'] = v }
  opts.on('-b', '--package [package name]', 'Location of bundle file') { |v| options['package'] = v }
  opts.on('-h', '--help', 'Help') { puts opts
  exit }
end.parse!

puts options['username']
puts options['password']
puts options['host']
puts options['file']
puts options['package']

if options['username'].nil?
  raise OptionParser::MissingArgument, "Need to specify a username"
elsif options['password'].nil?
  raise OptionParser::MissingArgument, "Need to specify a password"
elsif options['host'].nil?
  raise OptionParser::MissingArgument, "Need to specify a host and port"
elsif options['file'].nil?
  raise OptionParser::MissingArgument, "Need to specify a file location"
elsif options['package'].nil?
  raise OptionParser::MissingArgument, "Need to specify a package name"
end



puts "**Uploading & Installing Package: #{options['package']} at #{options['file']}"

uri = URI.parse("http://#{options['host']}/crx/packmgr/service.jsp")
request = Net::HTTP::Post::Multipart.new(uri.path,
                                         "install" => "true",
                                         "force" => "true",
                                         "name" => options['package'],
                                         "file" => UploadIO.new(options['file'], 'application/java-archive'))
request.basic_auth(options['username'], options['password'])
response = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(request)
end
puts "Response is #{response.code}"

sleep(sleep_time)

puts "**Package Release Complete**"
