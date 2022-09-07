Chef::Log.warn 'No CQ instances setup. Default recipe will only install author.'
include_recipe 'jmh-cq::author'
