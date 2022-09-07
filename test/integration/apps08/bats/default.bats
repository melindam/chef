
@test "Mongo DB is running" {
	run bash -c "mongo admin -u admin -p adminpassword --eval \"printjson(db.adminCommand('listDatabases'))\""
	[ "$status" -eq 0 ]
}

@test "VVisits YAML file exits" {
    run bash -c "test -a /home/nodejs/vvisits-local.yaml"
    [ "$status" -eq 0 ]
}

@test "VVisits newrelic file exits" {
    run bash -c "test -a /home/nodejs/vvisits-newrelic.js"
    [ "$status" -eq 0 ]
}

@test "NodeJS SSL Cert file exist" {
    run bash -c "test -a /home/nodejs/ssl/pem"
    [ "$status" -eq 0 ]
}

@test "NodeJS SSL Key file exist" {
    run bash -c "test -a /home/nodejs/ssl/key"
    [ "$status" -eq 0 ]
}