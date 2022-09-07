@test "Carbon is  available" {
	run bash -c "/usr/bin/systemctl status carbon-cache"
	[ "$status" -eq 0 ]
}

@test "Sensugo Backend is running" {
    run bash -c "systemctl status sensu-backend"
	[ "$status" -eq 0 ]
}

@test "Sensugo agent is running" {
    run bash -c "systemctl status sensu-agent"
	[ "$status" -eq 0 ]
}

@test "Sensu Authorizor Online " {
	run bash -c "curl -u 'admin:admin' -k https://localhost:8083/auth |  grep access_token "
	[ "$status" -eq 0 ]
}

@test "Sensu API Online " {
	run bash -c "curl -k https://127.0.0.1:8083/api/core/v2/namespaces/default/events -I | head -1 | grep \"HTTP/1.1 405\""
	[ "$status" -eq 0 ]
}

@test "Sensu Webport Online " {
	run bash -c "curl -k https://localhost:3000  -I |  head -1 | grep \"HTTP/1.1 400\""
	[ "$status" -eq 0 ]
}

@test "Graphite is running on 80" {
	run bash -c "curl -s -I --header 'Host: test-graphite.johnmuirhealth.com' http://localhost/account/login | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "netcat installed for testing" {
	run bash -c "yum -y install nc"
	[ "$status" -eq 0 ]
}

@test "Rundeck port open" {
	run bash -c "for v in {1..50} do nc -z localhost 4440; do sleep 1; done; nc -z localhost 4440;"
	[ "$status" -eq 0 ]
}

@test "Rundeck database is there" {
	run bash -c "mysql -h 127.0.0.1 -ppassword -D rundeck  -e 'show tables;'"
	[ "$status" -eq 0 ]
}

@test "Rundeck available" {
	run bash -c "curl -s -I http://localhost:4440 | head -1 | grep \"HTTP/1.1 302\""
	[ "$status" -eq 0 ]
}