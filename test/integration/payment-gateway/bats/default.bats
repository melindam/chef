
@test "payment-gateway /home/nodejs YAML file exits" {
    run bash -c "test -a /home/nodejs/payment-gateway-local.yaml"
    [ "$status" -eq 0 ]
}

@test "payment-gateway YAML file exits" {
    run bash -c "test -a /usr/local/nodeapp/payment-gateway/config/local.yaml"
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