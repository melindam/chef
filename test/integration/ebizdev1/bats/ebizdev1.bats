
@test "Tomcat JMPN is running" {
	run bash -c "curl -s -I http://localhost:8104/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SBO is running" {
	run bash -c "curl -s -I http://localhost:8103/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}