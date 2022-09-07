#!/usr/bin/env ruby -W0
require 'ridley'
require 'mixlib/shellout'

# yum list-sec
ssh_user = 'scott'

environments = ['awspoc']

ridley = Ridley.from_chef_config(".chef/knife.rb", {:ssl => {:verify => false}})


environments.each do |env|
  log_file = File.new("quarterly_updates_#{env}.log", 'w')
  nodes = ridley.search(:node, "chef_environment:#{env}", {:sort => 'chef_id DESC'})

  nodes.each  {|n|
    puts "**Now Updating #{n.name}**"
    log_file.puts "**Now Updating #{n.name}**"
    yum_command_list = ["sudo yum -y update --security",
                        "sudo yum -y update httpd mod_ssl php postfix openssh openssl tzdata mysql openldap"]
    yum_command_list.each do |ycommand|
      yum_command = Mixlib::ShellOut.new("knife ssh 'name:#{n.name}' '#{ycommand}' -x #{ssh_user}")
      log_file.puts ycommand
      yum_command.run_command
      puts yum_command.stdout
      log_file.puts yum_command.stdout
      puts yum_command.stderr
      log_file.puts yum_command.stderr
    end
  }
end


