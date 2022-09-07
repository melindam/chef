#!/usr/bin/env ruby
require 'chef-api'

# https://github.com/chef/chef-api
#

include ChefAPI::Resource

environments = ["arprod", "arstage", "awspoc2","awstst2","awstst","azutst"]

connection = ChefAPI::Connection.new(
    endpoint: 'https://api.opscode.com/organizations/jmhebiz',
    client:   ENV['OPSCODE_USER'],
    key:      "~/.chef/#{ENV['OPSCODE_USER']}.pem"
)
current_dir = Dir.pwd
repo_index = Dir.pwd.index('chef-repo')
chef_repo = File.join(current_dir[0,repo_index], 'chef-repo')
Dir.chdir chef_repo


apps = { "jmh-myjmh::db" => {"name" => "Profile Database", "port" => "3306", "context" => "", "nolink" => true},
         "jmh-events" => {"name" => "Event Manager", "port" => "8080", "context" => "events"},
         "jmh-fad::client" => {"name" => "Find a Doctor API", "port" => "8085", "context" => "fad"},
         "jmh-fad::db" => {"name" => "Find a Doctor DB & Admin", "port" => "8085", "context" => "fad/admin"},
         "jmh-prereg::admin" => {"name" => "Preregistration Admin", "port" => "8082", "context" => "prereg-admin"},
         "jmh-prereg::client" => {"name" => "Preregistration", "port" => "8081", "context" => "preregistration"},
         "jmh-myjmh::admin" => {"name" => "Profile Admin", "protocol" => 'https', "port" => "8467", "context" => "myjmh-admin"},
         "jmh-crowd::default" => {"name" => "Crowd", "port" => "8095", "context" => "crowd" },
         "jmh-cq::publisher" => {"name" => "Publisher", "port" => "4503", "context" => "content/jmh/en/home.html"},
         "jmh-cq::author" => {"name" => "Author", "port" => "4502", "context" => "libs/granite/core/content/login.html"},
         "jmh-cq::dispatcher" => {"name" => "Dispatcher", "port" => "80", "context" => ""},
         "jmh-monitor::sensu-server" => {"name" => "Sensu Server", "port" => "3000", "context" => ""},
         "jmh-rundeck" => {"name" => "Rundeck Server", "port" => "4440", "context" => ""},
         "jmh-webserver::php_site" => {"name" => "HR", "port" => "80", "context" => ""},
         "jmh-webserver::php_site_rollout" => {"name" => "PHP Rollout", "port" => "81", "context" => ""},
         "jmh-webserver::php_site_tag" => {"name" => "PHP Tag", "port" => "81", "context" => ""},
         "jmh-splunk::server" => {'name' => 'Splunk', 'port' => '80', 'context' => ""},
         "jmh-archiva::default" => {'name' => 'Archiva', 'port' => '8080', 'context' => "archiva"},
         "jmh-pingfed::pingfederate" => {'name' => 'PingFed Admin', 'protocol' => 'https', 'port' => '9999', 'context' => "pingfederate/app"},
         "jmh-webserver::mychart_proxy" => {'name' => 'MyChart Proxy', 'protocol' => 'https', 'port' => '443', 'context' => 'MyChart***'},
         "jmh-sched::scheduling" => {'name'=> 'Scheduling API', 'port'=> '8094','context'=> 'scheduling/pingCache'},
         "jmh-myjmh::profile-client" => {'name'=> 'Profile Client v2', 'protocol' => 'http', 'port'=> '8097','context'=> "profile-client"},
         "jmh-myjmh::profile_api" => {'name'=> 'Profile API', 'protocol' => 'https', 'port'=> '8465','context'=> "profile-api/docs"},
         "jmh-idev::comhub" => {'name'=> 'IDEV ComHub', 'protocol' => 'http', 'port'=> '8101', 'context'=> "comhub"},
         "jmh-idev::sbo" => {'name'=> 'IDEV SBO', 'protocol' => 'http', 'port'=> '8103', 'context'=> "sbo"},
         "jmh-idev::jmpn" => {'name'=> 'IDEV JMPN', 'protocol' => 'http', 'port'=> '8104', 'context'=> "jmpn"},
         "jmh-idev::mdsuspension" => {'name'=> 'IDEV MD Suspension', 'protocol' => 'http', 'port'=> '8105', 'context'=> "mdsuspension"},
         "jmh-idev::jmhapp_webserver" => {'name'=> 'IDEV Webserver', 'protocol' => 'https', 'port'=> '443', 'context'=> "index.html"},
         "jmh-idev::kcadapter" => {'name'=> 'IDEV KCAdapter', 'protocol' => 'http', 'port'=> '8520', 'context'=> "kcadapter-api/status"},
         "jmh-bamboo" => {'name'=> 'Bamboo', 'protocol' => 'http', 'port'=> '8085','context'=> 'bamboo'},
         "jmh-bamboo::bamboo_agent" => {'name'=> 'Bamboo Agent', 'protocol' => 'http', 'port'=> '8085','context'=> '/'},
	       "jmh-ci::jenkins" => {'name'=> 'Jenkins Agent', 'protocol' => 'http', 'port'=> '8080','context'=> '/jenkins'},
         "jmh-operations::ebiz_web_server" => {'name'=> 'EbizTools', 'port'=>'80','context'=> ""},
         "jmh-vvisits::vvisits_api" => {'name'=> 'VideoVisits API', 'protocol'=> 'https', 'port'=>'8521','context'=> "vvisits/v1/status"},
         "jmh-paygateway::payment_gateway" => {'name'=> 'Payment Gateway API', 'protocol'=> 'https', 'port'=>'8523','context'=> "gw/api/status"},
         "jmh-vvisits::mongodb" => {'name'=> 'VideoVisits MongoDB', 'context'=> "", "nolink" => true},
         "jmh-webproxy::supportportal" => {'name'=> 'SupportPortal', 'protocol'=> 'https', 'port'=>'443','context'=> ""},
         "jmh-webserver::dev_resources_web_server" => {'name'=> 'EbizDevResources', 'port'=>'80','context'=> ""},
         "jmh-webserver::webcommon" => {'name'=> 'WebCommon', 'port'=>'80','context'=> "webcommon"},
         "jmh-webserver::app_widgets" => {'name'=> 'AppWidgets', 'port'=>'80','context'=> "app_widgets"},
         "jmh-webserver::vvisits_client" => {'name'=> 'VideoVisits Client', 'port'=>'80','context'=> "vv"},
         "jmh-operations::analytics" => {'name'=> 'Analytics DB','context'=> "Analytics DB",'protocol' => 'https', "nolink" => true},
         "jmh-monitor::sensugo-backend" => {'name'=> 'SensuGo', 'port'=>'3000','protocol' => 'https','context'=> ""}
        }
# for the mychart prpxy changing context per environment
context_changes = { "jmh-webserver::mychart_proxy" => {"awstst" => "mycharttstsso/openscheduling",
                                                       "awstst2" => "mycharttst2sso/openscheduling",
                                                       "awspoc" => "mychartpocsso/openscheduling",
                                                       "arstage" => "mychartsupsso/openscheduling",
                                                       "arprod" => "mychartprdsso/openscheduling"}}


environments.each do |env|
  puts "h2.#{env.upcase}"
  puts "|| Name || IP/Hostname || Private IP || Services ||"
  nodelist = connection.search.query(:node, "chef_environment:#{env}", {:sort => 'chef_id DESC'})
  #puts nodelist.total
  nodelist.rows.each do |thing|
    services = []
    if thing['automatic']['cloud']
      if "#{thing['automatic']['cloud']['provider']}" == "ec2"
        hostname = thing['automatic']['cloud']['public_hostname']
      else
        hostname = thing['automatic']['cloud']['local_ipv4']
      end
    else
      hostname = thing['automatic']['ipaddress']
    end       
    apps.keys.each do |cr|
      if thing['automatic']['recipes'].include?(cr)
        if apps[cr]['nolink']
          services.push("#{apps[cr]['name']}")
        elsif apps[cr]['context']
          context = apps[cr]['context']
          if context_changes.has_key?(cr)
            context = context_changes[cr][env]
          end
          protocol = apps[cr]['protocol'] ? apps[cr]['protocol'] : 'http'
          port = ['80','443'].include?(apps[cr]['port']) ? '' : ":#{apps[cr]['port']}"
          services.push("#{apps[cr]['name']}:#{protocol}://#{hostname}#{port}/#{context}")
        else
          services.push("#{apps[cr]['name']}: #{hostname}#{port}")
        end
      end
    end
    if thing['automatic']['cloud']
      if "#{thing['automatic']['cloud']['provider']}" == "ec2"
        puts "|#{thing['name']}|#{thing['automatic']['cloud']['public_ipv4']}"
        print "#{hostname}|#{thing['automatic']['ipaddress']}|"
      else
        print "|#{thing['name']}|#{thing['automatic']['cloud']['local_ipv4']}| |"
      end 
    else
      print "|#{thing['name']}|#{hostname}| |"
    end
    if services.length != 0
      services.each do |s|
          puts s
      end
    else
      puts ' '
    end
    puts "|"
  end
end
