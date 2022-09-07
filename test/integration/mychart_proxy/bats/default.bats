
@test "Apache is running on 443" {
	run bash -c "curl -s -k -I https://localhost | head -1 | grep \"HTTP/1.1 403 Forbidden\""
	[ "$status" -eq 0 ]
}

@test "TSTTiles is proxying" {
	run bash -c "curl -s -k -I https://localhost/MyChartTSTTiles/ | head -1 | grep \"HTTP/1.1 500 Internal Server Error\""
	[ "$status" -eq 0 ]
	run bash -c "curl -s -k https://localhost/MyChartTSTTiles/ | grep 'You must enable JavaScript to use this site'"
	[ "$status" -eq 0 ]
}