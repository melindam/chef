# Used to get the java home for now
module JmhJavaUtil
  class << self
    def get_java_home(java_version, node)
      return ::File.join( node['jmh_java']['install_dir'],node['jmh_java']['jdk'][java_version]['version'])
    end

    def get_java_version(java_home, node)
      node['jmh_java']['jdk'].keys.each do |jv|
        next unless get_java_home(jv, node) == java_home
        return jv
      end
      Chef::Application.fatal!("Java Version Not found for java_home: #{java_home}")
    end

    def get_java_keytool_bin(java_version, node)
      Chef::Log.warn("***Java version is #{java_version}")
      case java_version
      when '6','7','8'
        return ::File.join(get_java_home(java_version, node), '/jre/bin/keytool')
      else
        return ::File.join(get_java_home(java_version, node), '/bin/keytool')
      end
    end

    def get_java_keystore_path(java_version, node)
      case java_version
      when '6','7','8'
        return ::File.join(get_java_home(java_version, node), '/jre/lib/security/cacerts')
      else
        return ::File.join(get_java_home(java_version, node), '/lib/security/cacerts')
      end
    end

    # Gets the java certs that need to be installed into a given environment
    def get_java_certs(node, java_version)
      return node['jmh_java']['final_cert_list'] if node['jmh_java']['final_cert_list']

      # Collect all certs into a hash
      cert_hash = Hash.new
      # JMH specific certs
      jmh_cert_databag = Chef::EncryptedDataBagItem.load(node['jmh_java']['java_security']['databag'],
                                                         node['jmh_java']['java_security']['jmh_cert_databag_item'])
      jmh_cert_databag['certs'].each_key do |cert_name|
        cert_hash[cert_name] = jmh_cert_databag['certs'][cert_name]
      end
      # jdk specific certs
      jdk_cert_databag = Chef::EncryptedDataBagItem.load(node['jmh_java']['java_security']['databag'],
                                                         node['jmh_java']['java_security']['jdk_cert_databag_item'])
      if jdk_cert_databag["certs#{java_version}"]
        jdk_cert_databag["certs#{java_version}"].each_key do |cert_name|
          cert_hash[cert_name] = jdk_cert_databag["certs#{java_version}"][cert_name]
        end
      end
      node['jmh_java']['java_security']['certs'].each do |cert|
        if cert['type'] == 'databag'
          cert_bag = Chef::EncryptedDataBagItem.load(cert['databag_folder'], cert['databag_file'])
          cert_hash[cert['name']] = cert_bag[cert['databag_item']]
        end
      end
      node.default['jmh_java']['final_cert_list'] = cert_hash
      return node['jmh_java']['final_cert_list']
    end
  end
end

