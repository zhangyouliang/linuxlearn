### ssl
> [如何创建自签名的 SSL 证书](https://www.jianshu.com/p/e5f46dcf4664)


1.自签名
----
    # 1. 生成私钥
    openssl genrsa -des3 -out server.key 1024
    
    # 2. 从秘钥中删除 Passphrase
    cp server.key server.key.org
    openssl rsa -in server.key.org -out server.key
    
    # 3. 生成 CSR (Certificate Signing Request)
    openssl req -new -key server.key -out server.csr
    
    # 4. 生成自签名证书
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
    
2.私有 CA 签名
----
    
    # 1.创建 CA 私钥
    openssl genrsa -des3 -out ca.key 4096
    
    # 2.生成 CA 的自签名证书
    openssl req -new -x509 -days 365 -key ca.key -out ca.crt
    
    # 3.生成需要颁发证书的私钥
    openssl genrsa -des3 -out server.key 4096
    
    # 4.生成要颁发证书的证书签名请求，证书签名请求当中的 Common Name 必须区别于 CA 的证书里面的 Common Name
    openssl req -new -key server.key -out server.csr
    
    # 5.用 2 创建的 CA 证书给 4 生成的 签名请求 进行签名
    openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt
    
   
区别：
---

　　自签名的证书无法被吊销，CA 签名的证书可以被吊销。

　　能不能吊销证书的区别在于：如果你的私钥被黑客获取，如果证书不能被吊销，则黑客可以伪装成你与用户进行通信。

　　如果你的规划需要创建多个证书，那么使用 私有 CA 的方法比较合适，因为只要给所有的客户端都安装了 CA 的证书，那么以该证书签名过的证书，客户端都是信任的，也就是安装一次就够了。

　　如果你直接用自签名证书，你需要给所有的客户端安装该证书才会被信任，如果你需要第二个证书，则还的挨个给所有的客户端安装证书2才会被信任。

