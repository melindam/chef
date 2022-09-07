
@test "Apache is running on 80" {
	run bash -c "curl -s -I http://127.0.0.1 --header 'Host: test-www.johnmuirhealth.com' | head -1 | grep \"HTTP/1.1 301 Moved Permanently\""
	[ "$status" -eq 0 ]
}

@test "Home page available" {
	run bash -c "curl -s -I http://127.0.0.1/content/jmh/en/home.html --header 'Host: test-www.johnmuirhealth.com' | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

@test "PRC home page available" {
	run bash -c "curl -s -I http://127.0.0.1/content/prc/en/home.html --header 'Host: test-prc.johnmuirhealth.com' | head -1 | grep \"HTTP/1.1 302 Found\""
	[ "$status" -eq 0 ]
}

@test "Home page available on ssl " {
	run bash -c "curl -s -k -I https://127.0.0.1/content/jmh/en/home.html  --header 'Host: test-www.johnmuirhealth.com' | head -1 | grep \"HTTP/1.1 200 OK\""
	[ "$status" -eq 0 ]
}

@test "API Host Server is up" {
	run bash -c "curl -k -s -I https://127.0.0.1/ --header 'Host: test-api.johnmuirhealth.com' | head -1 | grep \"HTTP/1.1 404 Not Found\""
	[ "$status" -eq 0 ]
}

@test "John Muir HR Server is up" {
	run bash -c "curl -k -s -I https://127.0.0.1/ --header 'Host: test-www.johnmuirhr.com' | head -1 | grep \"301 Moved Permanently\""
	[ "$status" -eq 0 ]
}

@test "Successful Server Error for api proxy" {
	run bash -c "curl -k -s -I https://127.0.0.1/scheduling/ --header 'Host: test-api.johnmuirhealth.com' | head -1 | grep \"HTTP/1.1 200\""
	[ "$status" -eq 0 ]
}

@test "MyChart Proxy translated to POC" {
	run bash -c "grep mychartpocsso /etc/httpd/conf/mychartsso_proxies.conf"
	[ "$status" -eq 0 ]
}

@test "Customphone book properly formatted" {
	run bash -c "file /var/www/html/customphonebook.xml | grep 'XML 1.0 document, Little-endian UTF-16 Unicode text'"
	[ "$status" -eq 0 ]
}