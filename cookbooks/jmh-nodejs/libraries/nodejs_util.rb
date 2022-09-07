module JmhNodejsUtil
  class << self
    def get_nodejs_home(nodejs_version, node)
      base_path =  File.basename(node['jmh_nodejs']['version'][nodejs_version]['download_url']).chomp('.tar.xz')
      return File.join(node['jmh_nodejs']['node_base_path'], base_path)
    end
  end
end