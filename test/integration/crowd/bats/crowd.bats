
@test "Crowd is running" {
	run bash -c "curl -s -I http://localhost:8095/ | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}