
@test "SupportPortal is running on http" {
	run bash -c "curl -s -I http://localhost/ | head -1 | grep \"HTTP/1.1 302\""
	[ "$status" -eq 0 ]
}

@test "SupportPortal is running on https" {
	run bash -c "curl -s -I https://localhost/ -k | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "SupportPortal Pregreg connection is running on https" {
	run bash -c "curl -s -I https://localhost/prereg-admin -k | head -1 | grep \"HTTP/1.1 302\""
	[ "$status" -eq 0 ]
}

@test "SupportPortal Myjmh Admin connection is running on https" {
	run bash -c "curl -s -I https://localhost/myjmh-admin -k | head -1 | grep \"HTTP/1.1 302\""
	[ "$status" -eq 0 ]
}

@test "Tomcat Prereg-admin is running" {
	run bash -c "curl -s -I http://localhost:8082/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SSL Prereg-admin is running" {
	run bash -c "curl -s -k -I https://localhost:8445/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Tomcat SSL Myjmh-admin is running" {
	run bash -c "curl -s -k -I https://localhost:8467/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}