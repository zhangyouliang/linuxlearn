#!/usr/bin/env bash

export PATH=$PATH:/usr/local/cfssl/

# cfssl print-defaults config > config/ca-config.json
# cfssl print-defaults csr > config/ca-csr.json


# ===> 生成CA证书和私钥
# 生成ca.pem、ca.csr、ca-key.pem(CA私钥,需妥善保管)
cfssl gencert -initca config/ca-csr.json | cfssljson -bare ca -

# 签发Server Certificate
# cfssl print-defaults csr > config/server.json

# ===> 生成服务端证书和私钥
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=config/ca-config.json -profile=kubernetes config/kubernetes-csr.json | cfssljson -bare kubernetes

#签发Client Certificate
#cfssl print-defaults csr > config/client.json

# ===> 生成 admin 证书和私钥
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=config/ca-config.json -profile=kubernetes config/admin-csr.json | cfssljson -bare admin



# ===> 生成客户端证书和私钥
# cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=config/ca-config.json -profile=client config/client.json | cfssljson -bare client

# 针对etcd服务,每个etcd节点上按照上述方法生成相应的证书和私钥

#最后校验证书
#校验生成的证书是否和配置相符

openssl x509 -in ca.pem -text -noout
openssl x509 -in kubernetes.pem -text -noout
openssl x509 -in admin.pem -text -noout

#  rm -rf *.pem *.csr#