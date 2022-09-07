
@test "Splunk is running on 8000" {
	run bash -c "curl -s -I http://localhost:8000/en-US/account/login?return_to=%2Fen-US%2F | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

