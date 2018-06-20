### cfssl 工具

生成CA证书和私钥
---
    cfssl gencert -initca config/ca-csr.json| cfssljson -bare ca
     
该命令会生成运行CA所必需的文件 `ca-key.pem（私钥）`和`ca.pem（证书）`，还会生成`ca.csr（证书签名请求`），用于交叉签名或重新签名。


证书生成与签名
---

kubernetes-csr.json

    {
      "CN": "Server",
      "hosts": [
        "127.0.0.1",
        "172.17.8.110",
        "172.17.48.1",
        "10.0.2.15",
        "kubernetes",
        "kubernetes.default",
        "kubernetes.default.svc",
        "kubernetes.default.svc.cluster",
        "kubernetes.default.svc.cluster.local"
      ],
      "key": {
        "algo": "rsa",
        "size": 2048
      },
      "names": [
        {
          "C": "CN",
          "ST": "BeiJing",
          "L": "BeiJing",
          "O": "k8s",
          "OU": "System"
        }
      ]
    }


ca-config.json
    
    {
      "signing": {
        "default": {
          "expiry": "8760h"
        },
        "profiles": {
          "kubernetes": {
            "usages": [
              "signing",
              "key encipherment",
              "server auth",
              "client auth"
            ],
            "expiry": "8760h"
          }
        }
      }
    }

创建证书

    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=config/ca-config.json -profile=kubernetes config/kubernetes-csr.json | cfssljson -bare kubernetes
    
    
前面已经提到过，该命令会生成三个文件，其中`kubernetes-key.pem`、`kubernetes.pem`和`kubernetes.csr`   

    
