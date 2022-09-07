default['cq']['publisher']['name'] = "publish01-#{node['cq']['cq_s3_key'].gsub(/[^0-9]/,'')}"
default['cq']['publisher']['max_memory'] = node['jmh_server']['environment'] == 'prod' ? '4096m' : '2048m'
default['cq']['publisher']['min_memory'] = node['jmh_server']['environment'] == 'prod' ? '4096m' : '2048m'

default['cq']['publisher']['port'] = 4503
default['cq']['publisher']['mode'] = 'publish'
default['cq']['publisher']['max_open_files'] = 50_000
default['cq']['publisher']['environment'] = case node['jmh_server']['environment']
                                            when 'prod', 'fhprod'
                                              'prod'
                                            when 'stage'
                                              'stage'
                                            else
                                              'dev'
                                            end
default['cq']['publisher']['show_sample_content'] = %w(prod stage).include?(node['cq']['publisher']['environment']) ? false : true
default['cq']['publisher']['disable_tar_compaction'] = false

default['cq']['publisher']['user_asset'] = { 'sbx' => 'publisher/publisher-dev-users-1.0.zip',
                                             'dev' => 'publisher/publisher-dev-users-1.0.zip',
                                             'stage' => 'publisher/publisher-stage-users-1.0.zip',
                                             'prod' => 'publisher/publisher-prod-users-1.0.zip' }

default['cq']['publisher']['content_assets'] = %w(
  publisher/jmhbackup-pub-content-jmh.zip
  publisher/jmhbackup-pub-dam-jmh-documents-a-m.zip
  publisher/jmhbackup-pub-dam-jmh-documents-n-z.zip
  publisher/jmhbackup-pub-dam-jmh-no-documents.zip
  publisher/jmhbackup-pub-content-prc.zip
  publisher/jmhbackup-pub-dam-prc.zip
  publisher/jmhbackup-pub-forms.zip
)

default['cq']['publisher']['asset_zips'] = []
default['cq']['publisher']['asset_checksums'] = {}
default['cq']['publisher']['jmx_port'] = 6963
default['cq']['publisher']['check_page']['url_suffix'] = '/content/jmh/en/home.html'
