# Definition provided from this cookbook

jmh_cq_instance node['cq']['author']['mode'] do
  disable_tar_compaction node['cq']['author']['disable_tar_compaction']
  action :install
end
