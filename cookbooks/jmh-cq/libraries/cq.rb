require 'tmpdir'
require 'net/http'

# Used to help out with REST statements, installs, and uploads to jmh-cq
# https://gist.github.com/sergeimuller/2916697
module CQ
  class << self
    def md5_for(path)
      require 'digest/md5'
      m = Digest::MD5.new
      File.open(path) do |file|
        m << file.read(1024) until file.eof?
      end
      m.hexdigest
    end

    def sha256_for(path)
      require 'digest/sha2'
      m = Digest::SHA256.new
      File.open(path) do |file|
        m << file.read(1024) until file.eof?
      end
      m.hexdigest
    end

    def extract_bundle_name_version(jar)
      res = {}
      Dir.mktmpdir do |dir|
        cmd = MixLib::Shellout.new("unzip #{jar} -d #{dir}")
        cmd.run_command
        Dir.glob('**/pom.properties').each do |prop_file|
          file = File.readlines(prop_file)
          v = file.find { |l| l.start_with?('version') }.to_s.split('=').last.to_s.strip
          res[:version] = Chef::Version.new(v).to_s unless v.empty?
          n = %w(groupId artifactId).map do |k|
            file.find { |l| l.start_with?(k) }.to_s.split('=').last.to_s.strip
          end
          unless n.empty?
            n.last.sub!("#{n.first.split('.').last}-", '')
            res[:name] = n.join('.')
          end
        end
      end
      res if res[:version] && res[:name]
    end

    def bundle_installed?(jar, cq_port, username, password)
      jar_info = extract_bundle_name_version(jar)
      uri = URI("http://localhost:#{cq_port}/system/console/bundles.json")
      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth username, password
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end
      res.value
      info = Mash.new(JSON.load(res.body))
      !!info[:data].find do |bndl_hsh|
        bndl_hsh[:symbolicName] == jar_info[:name] && bndl_hsh[:version] == jar_info[:version]
      end
    end

    # TODO: Swap out curl for proper net::http usage.
    def bundle_install(jar, port, username, password)
      com = "curl -u #{username}:#{password} -F action=install -F bundlestart=start -F bundlestartlevel=20 " \
        "-F bundlefile=@\"#{jar}\" http://localhost:#{port}/system/console/bundles > /dev/null 2>&1"
      cmd = MixLib::Shellout.new(com)
      cmd.run_command
      if cmd.error?
        fail "Failed to install CQ required bundle: #{File.basename(jar)}"
      else
        Chef::Log.info "Uploaded bundle package required for CQ: #{File.basename(jar)}"
      end
    end

    def is_port_open?(port)
      begin
        Chef::Log.warn('Check if port is open')
        Timeout.timeout(1) do
          begin
            s = TCPSocket.new('localhost', port)
            s.close
            return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            Chef::Log.warn('Connection Refused!')
            return false
          end
        end
      rescue Timeout::Error
      end
      false
    end

    def isAEMOnline?(port)
      uri_string = "http://127.0.0.1:#{port}/libs/granite/core/content/login.html"
      Chef::Log.debug("URI IS #{uri_string}")

      uri = URI(uri_string)
      res = Net::HTTP.get_response(uri)
      Chef::Log.debug('Response looks like:' + res.body)
      Chef::Log.debug('AEM Response code is:' + res.code)
      if res.code  == '200'
        Chef::Log.warn("AEM is Up")
        return true
      else
        Chef::Log.warn("AEM is still booting")
        return false
      end
    end

    def valid_credentials?(port, username, password)
      uri_string = "http://localhost:#{port}/crx/packmgr/service.jsp?cmd=ls"
      Chef::Log.debug("URI IS #{uri_string}")

      uri = URI(uri_string)
      req = Net::HTTP::Post.new(uri.request_uri, 'cmd' => 'ls')
      req.basic_auth username, password
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end
      Chef::Log.debug('Response looks like:' + res.body)
      Chef::Log.debug('Response code is:' + res.code)
      if res.body.include?('<group>adobe/granite</group>')
        return true
      else
        return false
      end
    end

    def get_user_home(port, username, password)
      # output = %x(curl -s -u admin:#{admin_password} -X GET "#{url}/bin/querybuilder.json?path=/home/users&1_property=rep:authorizableId&1_property.value=#{username}&p.limit=-1")
      uri_string = "http://localhost:#{port}/bin/querybuilder.json"
      Chef::Log.debug("URI IS #{uri_string}")

      uri = URI(uri_string)
      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data('path' => '/home/users',
                        '1_property' => 'rep:authorizableId',
                        '1_property.value' => username,
                        'p.limit' => '-1')
      req.basic_auth username, password
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end
      Chef::Log.debug('Res looks like:' + res.body)
      Chef::Log.debug('Response code is:' + res.code)
      if res.code == '200'
        output_hash = JSON.load(res.body)
        hits_hash = output_hash['hits'][0]
        Chef::Log.debug("Path is #{hits_hash['path']}")
        return hits_hash['path']
      else
        Chef::Log.fatal("I could find the path for #{username}")
      end
    end

    def update_admin_password(port, username, password, new_password)
      # curl -s -u admin:admin -Fplain={NEW_PASSWORD} -Fverify={NEW_PASSWORD} -Fold={OLD_PASSWORD} -X POST http://localhost:4502/crx/explorer/ui/setpassword.jsp
      Chef::Log.debug("New Pass: #{new_password}")
      uri_string = "http://localhost:#{port}/crx/explorer/ui/setpassword.jsp"
      uri = URI(uri_string)
      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data('plain' => new_password,
                        'verify' => new_password,
                        'old' => password)
      req.basic_auth username, password
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.request(req)
      end
      Chef::Log.debug("Update password response is #{res.body}")
      Chef::Log.debug("Update password response code is #{res.code}")
      if !valid_credentials?(port, username, new_password)
        Chef::Log.fatal('Update password response has failed')
      else
        Chef::Log.warn('Password is updated!')
      end
      true
    end

    def uploaded?(jar, port, username, password, context)
      pack_dir = context.nil? ? '/crx/packmgr/service/.json/etc/packages' : context
      package_location = "http://localhost:#{port}#{pack_dir}"
      Chef::Log.debug("URI IS #{package_location}/#{jar}?cmd=preview")

      begin
        uri = URI("#{package_location}/#{jar}?cmd=preview")
        req = Net::HTTP::Post.new(uri.request_uri, 'cmd' => 'preview')
        req.basic_auth username, password
        res = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end
        Chef::Log.debug('Res looks like:' + res.body)
        res = Mash.new(JSON.load(res.body))
        return res[:success]
      rescue => e
        Chef::Log.warn("An error of type #{e.class} happened, message is #{e.message}")
        Chef::Log.warn('Failed lookup for package:' + jar)
        return false
      end

    end

    def upload(jar, port, username, password)
      require 'net/http/post/multipart'
      uri = URI("http://localhost:#{port}/crx/packmgr/service/.json/?cmd=upload")
      res = nil
      File.open(jar) do |file|
        req = Net::HTTP::Post::Multipart.new(
          uri.path, 'package' => UploadIO.new(file, '', jar), 'cmd' => 'upload'
        )
        req.basic_auth username, password
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
      end
      #res.value
      res = Mash.new(JSON.load(res.body))
      if res[:success]
        Chef::Log.info "Uploaded CQ package: #{File.basename(jar)}"
        res[:path]
      else
        Chef::Log.fatal "Failed to upload CQ package: #{File.basename(jar)} - Reason: #{res[:msg]}"
        fail "CQ: Failed to upload: #{File.basename(jar)} - Reason: #{res[:msg]}"
      end
    end

    def install(path, port, username, password)
      context = '/crx/packmgr/service/.json'
      uri = URI("http://localhost:#{port}#{context}#{path}?cmd=install")
      req = Net::HTTP::Post.new(uri.request_uri, 'cmd' => 'install')
      req.basic_auth username, password
      Chef::Log.info "Now attempting to install #{path}"
      begin
        res = Net::HTTP.start(uri.host, uri.port) do |http|
          http.request(req)
        end
        Chef::Log.info "Now done #{path}"
        res.value
        res = Mash.new(JSON.load(res.body))
        Chef::Log.debug "The result from the install is: #{res}"
        if res[:success]
          Chef::Log.info "Installed CQ package: #{File.basename(path)}"
        else
          Chef::Log.fatal "Failed to install CQ package: #{File.basename(path)} - Reason: #{res[:msg]}"
          fail "Failed to install CQ package: #{File.basename(path)} - Reason: #{res[:msg]}"
        end
      rescue
        Chef::Log.fatal "Failed executing the install of the package: #{path}"
      end
    end


    def upload_and_install(jar, port, username, password)
      #curl -u admin:admin -F file=@"name of zip file" -F name="name of package" -F force=true -F install=true http://localhost:4505/crx/packmgr/service.jsp
      require 'net/http/post/multipart'
      require 'nokogiri'
      uri = URI("http://localhost:#{port}/crx/packmgr/service.jsp")
      path = uri.path
      begin
        res = nil
        File.open(jar) do |file|
          req = Net::HTTP::Post::Multipart.new(
            uri.path, 'file' => UploadIO.new(file, '', jar), 'name' => jar, 'install' => true
          )
          req.basic_auth username, password
          res = Net::HTTP.start(uri.hostname, uri.port) do |http|
            http.request(req)
          end
        end
        #res.value
        result = Nokogiri::XML(res.body)
        #Chef::Log.warn("****" + result.to_s + "****")
        return_status = result.at_css("response status").content
        return_code = result.at_css("response status")['code']
        if return_code == '200'
          Chef::Log.warn "CQ package: #{File.basename(jar)} uploaded and install sucessfully"
          res[:path]
        else
          Chef::Log.fatal "Failed to upload CQ package: #{File.basename(jar)} - Code: #{return_code} - Reason: #{return_status}"
          fail "Failed to upload CQ package: #{File.basename(jar)} - Code: #{return_code} - Reason: #{return_status}"
        end
      rescue
        Chef::Log.fatal "Failed executing the upload/install of the package: #{path}/ #{result.to_s}"
      end
    end

    def generate_dispatcher_conf(data_hash, nest = 0)
      output = []
      data_hash.each do |key, value|
        if value.is_a?(Hash)
          output << "#{' ' * nest}/#{key}\n#{' ' * nest}{\n#{generate_dispatcher_conf(value, nest + 2)}\n#{' ' * nest}}"
        elsif value.is_a?(Array)
          val = value.map do |v|
            "#{' ' * (nest + 2)}\"#{v}\""
          end.join("\n")
          output << "#{' ' * nest}/#{key}\n#{' ' * nest}{\n#{val}\n#{' ' * nest}}"
        else
          # some of the values work better with single quotes
          if %w(extension selectors).include?(key)
            output << "#{' ' * nest}/#{key} '#{value}'"
          else
            output << "#{' ' * nest}/#{key} \"#{value}\""
          end
        end
      end
      output.join("\n")
    end

    def crawl_for_envs(hash, maps)
      new_hash = {}
      hash.each do |k, v|
        new_key = env_replace(k, maps)
        if v.is_a?(Hash)
          new_val = crawl_for_envs(v, maps)
        elsif v.is_a?(String)
          new_val = env_replace(v, maps)
        elsif v.is_a?(Array)
          new_val = v.map do |val|
            val.is_a?(String) ? env_replace(val, maps) : val
          end
        else
          new_val = v
        end
        new_hash[new_key] = new_val
      end
      new_hash
    end

    def env_replace(value, maps)
      new_val = value.dup
      maps.each do |env_name, env_value|
        rep = "%{#{env_name.upcase}}"
        new_val.gsub!(rep, env_value)
      end
      new_val
    end

    def geo_installed?(port, username, password)
      com = "curl -u #{username}:'#{password}' http://localhost:#{port}/content/geometrixx/en.html | grep '<title>' | grep English > /dev/null 2>&1"
      cmd = Mixlib::ShellOut.new(com)
      cmd.run_command
      if cmd.error?
        Chef::Log.info 'Geometrixx NOT installed'
        return false
      else
        Chef::Log.info 'Geometrixx is installed'
        return true
      end
    end

    def geo_remove(port, username, password, geo_sites)
      geo_sites.each do |site|
        com = "curl -u #{username}:'#{password}' http://localhost:#{port}/ -F':operation=delete' -F':applyTo=#{site}' > /dev/null 2>&1"
        cmd = Mixlib::ShellOut.new(com)
        cmd.run_command
        if cmd.error?
          fail "FAILURE when trying to remove site=#{site} that should be removed"
        else
          Chef::Log.info "Removed site = #{site}"
        end
      end
    end

    def node_exists?(port, username, password, aem_node)
      com = "curl -u #{username}:'#{password}' http://localhost:#{port}/#{aem_node} -I"
      cmd = Mixlib::ShellOut.new(com)
      cmd.run_command
      if cmd.error?
        Chef::Log.warn("Problem reading node:#{aem_node}. Error Code: #{cmd.exitstatus}")
        return false
      end
      Chef::Log.warn("Result from node call: #{cmd.stdout}")

      if cmd.stdout.include?('HTTP/1.1 200')
        return true
      end
      return false
    end

    def node_remove(port, username, password, aem_node)
      com = "curl -u #{username}:'#{password}' http://localhost:#{port}/ -F':operation=delete' -F':applyTo=#{aem_node}' > /dev/null 2>&1"
      cmd = Mixlib::ShellOut.new(com)
      cmd.run_command
      if cmd.error?
        fail "FAILURE when trying to remove node=#{aem_node} that should be removed"
        return false
      else
        Chef::Log.warn("Removed node = #{aem_node}")
      end
      return true
    end

  end
end
