@test "Jenkins is running" {
	run bash -c "sleep 5; curl -s -I http://localhost:8080/jenkins/ | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

@test "nodejs installed " {
	run bash -c "ls /usr/local/nodejs/node*"
	[ "$status" -eq 0 ]
}