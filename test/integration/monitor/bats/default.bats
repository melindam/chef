
@test "Apache is running on 80" {
	run bash -c "curl -s -I http://localhost | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Rundeck database is there" {
	run bash -c "mysql -h 127.0.0.1 -ppassword -D rundeck  -e 'show tables;'"
	[ "$status" -eq 0 ]
}

@test "Rundeck available" {
	run bash -c "sleep 10; curl -s -I http://localhost:4440 | head -1 | grep \"HTTP/1.1 302\""
	[ "$status" -eq 0 ]
}

@test "Rabbitmq Permissions Set" {
	run bash -c "/usr/sbin/rabbitmqctl list_permissions -p '/sensu' | grep '*' "
	[ "$status" -eq 0 ]
}

@test "Carbon is  available" {
	run bash -c "/usr/bin/systemctl status carbon-cache"
	[ "$status" -eq 0 ]
}

@test "Redis available" {
	run bash -c "ps ax | fgrep redis | fgrep -v 'grep'"
	[ "$status" -eq 0 ]
}

@test "Sensu API Online " {
	run bash -c "curl -s -I http://localhost:4567/clients | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "Uchiwa Online " {
	run bash -c "curl -s -I -k https://localhost:3000 | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}
