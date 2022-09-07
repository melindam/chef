require 'tmpdir'
require 'net/http'

# Used to help out with REST statements, installs, and uploads to jmh-cq
module WebserverUtil
  class << self
    def crawl_for_envs(hash, maps)
      new_hash = {}
      hash.each do |k, v|
        new_key = env_replace(k, maps)
        if v.kind_of?(Hash)
          new_val = crawl_for_envs(v, maps)
        elsif v.kind_of?(String)
          new_val = env_replace(v, maps)
        elsif v.kind_of?(Array)
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
    
    
  end
end