
@test "Webserver is running" {
	run bash -c "curl -s -k -I https://localhost/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Sensu Proxy Made" {
	run bash -c "ls /etc/httpd/sites-available | grep sensu"
	[ "$status" -eq 0 ]
}

@test "No proxies to localhost" {
	run bash -c "grep localhost /etc/httpd/sites-available/*"
	[ "$status" -eq 1 ]
}
