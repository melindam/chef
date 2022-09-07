@test "Apache Rollout Site is running on 81" {
	run bash -c "curl -s -I http://localhost:81 | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

@test "Apache Custom Site is running on 82" {
	run bash -c "curl -s -I http://localhost:82/custom | head -1 | grep \"HTTP/1.1 301 Moved Permanently\""
	[ "$status" -eq 0 ]
}
