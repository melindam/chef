
@test "Publisher is running" {
	run bash -c "curl -s -I http://localhost:4503/crx/explorer/index.jsp | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}


@test "Webserver is running" {
	run bash -c "curl -s -k -I https://localhost/server-status | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

