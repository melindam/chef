@test "Apache webserver is running" {
	run bash -c "curl -s -k -I https://localhost:443/ | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "NodeJS Home YAML file is there"  {
	run bash -c "ls -l /home/nodejs/kcadapter-api-local.yaml"
	[ "$status" -eq 0 ]
}

@test "NodeJS Application YAML file is there"  {
	run bash -c "ls -l /usr/local/nodeapp/kcadapter-api/config/local.yaml"
	[ "$status" -eq 0 ]
}

