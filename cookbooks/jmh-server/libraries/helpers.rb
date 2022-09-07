module JmhServerHelpers
  class << self
    def rhel7?(node)
      return true if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 7
      false
    end
  end
end