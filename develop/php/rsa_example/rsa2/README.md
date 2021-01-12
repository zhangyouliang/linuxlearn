第三方工具: http://www.metools.info/code/c81.html

````
openssl genrsa -out rsa_private_key.pem 1024
openssl pkcs8 -topk8 -inform PEM -in rsa_private_key.pem -outform PEM -nocrypt -out private_key.pem
openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
````
> 从上面看出通过私钥能生成对应的公钥，因此我们将私钥 private_key.pem 用在服务器端，公钥发放给android跟ios等前端
>
- 第一条命令生成原始 RSA私钥文件 rsa_private_key.pem
- 第二条命令将原始 RSA私钥转换为 pkcs8 格式
- 第三条生成RSA公钥 rsa_public_key.pem

