name 'ebiz-tools'

description 'Builds ebiz-tools applications'

run_list(
  "role[jmh-local]",
  "recipe[jmh-webserver]",
  "recipe[jmh-operations::subversion]",
  "recipe[jmh-operations::awstats]",
  "recipe[jmh-operations::archive_database_backups]",
  "recipe[jmh-operations::archive_fad_images]",
  "recipe[jmh-operations::archive_archiva_repo]",
  "recipe[jmh-operations::cq_archives]",
  "recipe[jmh-operations::reports]",
  "recipe[jmh-operations::shared_folder]",
  "recipe[jmh-operations::backup_pingfed]",
  "recipe[jmh-operations::echo_import_dev]",
  "recipe[jmh-operations::archive_videovisits_logs]",
  "recipe[jmh-operations::mdsuspension_echo_import]",
  "recipe[jmh-utilities::hostsfile_all_chef_clients]"
)
