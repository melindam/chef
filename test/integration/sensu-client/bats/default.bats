@test "Sensu Client is running" {
	run bash -c "ps ax | grep sensu-client | grep -v grep"
	[ "$status" -eq 0 ]
}