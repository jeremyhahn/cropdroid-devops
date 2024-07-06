#!/usr/bin/env bash
set -eu
org=CropDroid
domain=dev.cropdroid.com
dir=keys/

#sudo trust anchor --remove "$dir/ca.crt" || true

openssl genpkey -algorithm RSA -out "$dir/ca.key"
openssl req -x509 -key "$dir/ca.key" -out "$dir/ca.crt" -subj "/CN=$org/O=$org"

openssl genpkey -algorithm RSA -out "$dir/$domain.key" -config keys/openssl.cnf
openssl req -new -key "$dir/$domain.key" -out "$dir/$domain.csr" -config keys/openssl.cnf

openssl x509 -req -in "$dir/$domain".csr -days 365 -out "$dir/$domain".crt \
    -CA "$dir/ca.crt" -CAkey "$dir/ca.key" -CAcreateserial \
    -extensions v3_req \
    -extfile <(cat <<END
[ v3_req ]
basicConstraints       = CA:false
#keyUsage               = keyEncipherment, dataEncipherment
extendedKeyUsage       = serverAuth
subjectAltName         = @sans	
#subjectKeyIdentifier   = hash
#authorityKeyIdentifier = keyid,issuer

[ sans ]
DNS.0 = localhost
DNS.1 = dev.cropdroid.com
DNS.2 = foo.bar.com
IP.1 = 192.168.1.20
email.1 = root@test.com
END
    )

# openssl x509 -req -in "$dir/$domain.csr" -days 365 -out "$dir/$domain.crt" \
#     -CA "$dir/ca.crt" -CAkey "$dir/ca.key" -CAcreateserial \
#     -extensions v3_req \
#     -extfile keys/openssl.cnf

#sudo trust anchor --store "$dir/ca.crt"
sudo cp "$dir/ca.crt" "/usr/local/share/ca-certificates/$org-ca.crt"
sudo cp "$dir/$domain.crt" "/usr/local/share/ca-certificates/$domain.crt"
sudo update-ca-certificates
