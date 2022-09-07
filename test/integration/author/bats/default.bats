

@test "Sleep for 30" {}

@test "Author is running" {
    run bash -c "sleep 30; curl -s -I http://localhost:4502/ | head -1 | grep \"HTTP/1.1 401 Unauthorized\""
    [ "$status" -eq 0 ]
}

@test "Webserver is running" {
    run bash -c "curl -s -k -I https://localhost/ | head -1 | grep \"HTTP/1.1 401 Unauthorized\""
    [ "$status" -eq 0 ]
}
