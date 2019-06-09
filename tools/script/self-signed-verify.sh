#!/bin/bash -e



openssl verify -CAfile cacerts.pem tls.crt

openssl x509 -in tls.crt -noout -text

# openssl s_client -connect demo.rancher.com:443 -servername demo.rancher.com -CAfile cacerts.pem