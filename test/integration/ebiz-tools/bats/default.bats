
@test "Ebiz Webserver is running" {
	run bash -c "curl -s -I http://localhost/index.html | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

@test "Shared Folder is up" {
	run bash -c "curl -s -I http://localhost/share/ | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

#@test "Subversion is running" {
#	run bash -c "curl -s -I http://localhost/repos/ondemand | head -1 | grep \"HTTP/1.1 401\""
#	[ "$status" -eq 0 ]
#}

@test "Reporting is running" {
	run bash -c "curl -s -I http://localhost/reporting/ | head -1 | grep \"HTTP/1.1 401\""
	[ "$status" -eq 0 ]
}

@test "awstats is up" {
	run bash -c "curl -s -I http://localhost/awstats/awstats.pl?config=www.johnmuirhealth.com | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

@test "rsync is installed" {
  run bash -c "rpm -qa | grep rsync"
  [ "$status" -eq 0 ]
}
