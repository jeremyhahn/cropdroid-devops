#!/usr/bin/env bash

# https://certbot.eff.org/instructions?ws=other&os=ubuntufocal

set -eu
org=CropDroid
domain=dev.cropdroid.com
hostname=`hostname -I | cut -d ' ' -f1`
dir=keys

mkdir -p $dir

openssl genrsa -des3 -out $dir/ca.key 2048
openssl req -x509 -new -nodes -key $dir/ca.key -sha256 -days 365 -out $dir/ca.key.pem -config openssl-distinguished-name.cnf

openssl req -new -sha256 -nodes -out $dir/server.csr -newkey rsa:2048 -keyout $dir/server.key -config <(cat <<END
[ v3_req ]
basicConstraints       = CA:false
extendedKeyUsage       = serverAuth
subjectAltName         = @sans
authorityKeyIdentifier = keyid,issuer
keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment

[ sans ]
DNS.0 = localhost
DNS.1 = $domain
IP.1 = $hostname
email.1 = root@test.com
END
    )

openssl x509 -req \
    -in dir/server.csr \
    -CA $dir/ca.key.pem \
    -CAkey $dir/ca.key \
    -CAcreateserial \
    -out $dir/server.crt \
    -days 365 \
    -sha256 \
    -config openssl.cnf \
    -extfile <(cat <<END
[ v3_req ]
basicConstraints       = CA:false
extendedKeyUsage       = serverAuth
subjectAltName         = @sans
authorityKeyIdentifier = keyid,issuer
keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment

[ sans ]
DNS.0 = localhost
DNS.1 = $domain
IP.1 = $hostname
email.1 = root@test.com
END
    )
    -

# openssl genpkey -algorithm RSA -out "$dir/ca.key"
# openssl req -x509 -key "$dir/ca.key" -out "$dir/ca.crt" -subj "/CN=$org/O=$org"

# openssl genpkey -algorithm RSA -out "$dir/$domain.key" -config openssl-minimal.cnf
# openssl req -new -key "$dir/$domain.key" -out "$dir/$domain.csr" -config openssl-minimal.cnf

# openssl x509 -req -in "$dir/$domain".csr -days 365 -out "$dir/$domain".crt \
#     -CA "$dir/ca.crt" -CAkey "$dir/ca.key" -CAcreateserial \
#     -extensions v3_req \
#     -extfile <(cat <<END
# [ v3_req ]
# basicConstraints       = CA:false
# extendedKeyUsage       = serverAuth
# subjectAltName         = @sans
# authorityKeyIdentifier = keyid,issuer
# keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment

# [ sans ]
# DNS.0 = localhost
# DNS.1 = $domain
# IP.1 = $hostname
# email.1 = root@test.com
# END
#     )

# ... or use the full config instead of the command above ....
# openssl x509 -req -in "$dir/$domain.csr" -days 365 -out "$dir/$domain.crt" \
#     -CA "$dir/ca.crt" -CAkey "$dir/ca.key" -CAcreateserial \
#     -extensions v3_req -extfile keys/openssl.cnf

sudo cp "$dir/ca.crt" "/usr/local/share/ca-certificates/$org-ca.crt"
sudo cp "$dir/$domain.crt" "/usr/local/share/ca-certificates/$domain.crt"
sudo update-ca-certificates

cp $dir/$domain.key ../../src/go-cropdroid/keys/server.key
cp $dir/$domain.crt ../../src/go-cropdroid/keys/server.crt

# Verify SANS
# openssl s_client -connect $domain:8091  | openssl x509 -noout -text
# openssl s_client -connect $hostname:8091  | openssl x509 -noout -text
# openssl s_client -connect localhost:8091  | openssl x509 -noout -text

# Debug certificate
# openssl s_client -debug -connect localhost:8091

# Copy src/go-cropdroid/keys/server.crt to cropdroid-android/res/raw/server_certificate_self_signed
