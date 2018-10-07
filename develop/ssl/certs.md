ssl 证书相关
----

SSL使用证书来创建安全连接。有两种验证模式:
- 仅客户端验证服务器的证书，客户端自己不提供证书； 
- 客户端和服务器都互相验证对方的证书。
一般第二种方式用于网上银行等安全性要求较高的网站，普通的Web网站只采用第一种方式

证书类型
----
x509的证书编码格式有两种:

- PEM(Privacy-enhanced Electronic Mail)是明文格式的,以 —–BEGIN CERTIFICATE—–开头，已—–END CERTIFICATE—–结尾。中间是经过base64编码的内容,apache需要的证书就是这类编码的证书.查看这类证书的信息的命令为: `openssl x509 -noout -text -in server.pem`。其实PEM就是把DER的内容进行了一次base64编码的内容
- DER是二进制格式的证书，查看这类证书的信息的命令为: `openssl x509 -noout -text -inform der -in server.der`

扩展名
----
- .crt证书文件,可以是DER(二进制)编码的，也可以是PEM(ASCII (Base64))编码的),在类unix系统中比较常见;
- .cer也是证书，常见于Windows系统。编码类型同样可以是DER或者PEM的，windows下有工具可以转换crt到cer；
- .csr证书签名请求文件，一般是生成请求以后发送给CA，然后CA会给你签名并发回证书
- .key一般公钥或者密钥都会用这种扩展名，可以是DER编码的或者是PEM编码的。查看DER编码的(公钥或者密钥)的文件的命令为: openssl rsa -inform DER -noout -text -in xxx.key。查看PEM编码的(公钥或者密钥)的文件的命令为: openssl rsa -inform PEM -noout -text -in xxx.key;
- .p12证书文件,包含一个X509证书和一个被密码保护的私钥;

自签名类型
----
> 自签名证书的Issuer和Subject是相同的。

- 自签名证书
- 私有CA签名证书

生成自签名证书
----

创建root CA私钥

    openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout ca.key \
    -x509 -days 365 -out ca.crt

为服务端(web)生成证书签名请求文件

如果你使用类似demo.rancher.com的FQDN域名访问，则需要设置demo.rancher.com作为CN；如果你使用IP地址访问，CN则为IP地址：

    openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout demo.rancher.com.key \
    -out  demo.rancher.com.csr

> 注意: Commone Name一定要是你要授予证书的FQDN域名或主机名，并且不能与生成root CA设置的Commone Name相同，challenge password可以不填。

用第一步创建的CA证书给第二步生成的签名请求进行签名

    openssl x509 -req -days 365 -in demo.rancher.com.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out demo.rancher.com.crt

如果你使用IP，例如192.168.1.101来连接，则可以改为运行以下命令：

    echo 'subjectAltName = IP:192.168.1.101' > extfile.cnf
    openssl x509 -req -days 365 -in demo.rancher.com.csr -CA ca.crt -CAkey ca.key -CAcreateserial -extfile extfile.cnf -out  demo.rancher.com.crt


最终生成文件: ca.crt  ca.key  ca.srl  demo.rancher.com.crt  demo.rancher.com.csr  demo.rancher.com.key

#### # 判断 key 的类型,是 DER,PEM格式?

    # 分别使用下面命令进行验证,解析出来则为对应的格式
    openssl rsa -inform DER -noout -text -in xxx.key
    openssl rsa -inform PEM -noout -text -in xxx.key

#### # 判断证书编码类型?

    # 注意格式不一定为 pem,也可能为 crt 格式,解析出来则为对应的格式
    openssl x509 -noout -text -in server.pem
    openssl x509 -noout -text -inform der -in server.der

#### # 证书验证
> 当证书配置好之后可以使用下面命令比较一些,使用ca证书和不使用的却别,参考,[]rancher 文档](https://www.cnrancher.com/docs/rancher/v2.x/cn/installation/self-signed-ssl/)

    openssl s_client -connect rancher.whatdy.com:443 -servername rancher.whatdy.com
    openssl s_client -connect rancher.whatdy.com:443 -servername rancher.whatdy.com -CAfile ca.crt

#### # openssl、x509、crt、cer、key、csr、ssl、tls 这些都是什么鬼?

- TLS：传输层安全协议 Transport Layer Security的缩写
- SSL：安全套接字层 Secure Socket Layer的缩写

TLS与SSL对于不是专业搞安全的开发人员来讲，可以认为是差不多的，这二者是并列关系，详细差异见 http://kb.cnblogs.com/page/197396/

- KEY 通常指私钥。
- CSR 是Certificate Signing Request的缩写，即证书签名请求，这不是证书，可以简单理解成公钥，生成证书时要把这个提交给权威的证书颁发机构。
- CRT 即 certificate的缩写，即证书。
- X.509 是一种证书格式.对X.509证书来说，认证者总是CA或由CA指定的人，一份X.509证书是一些标准字段的集合，这些字段包含有关用户或设备及其相应公钥的信息。

X.509的证书文件，一般以.crt结尾，根据该文件的内容编码格式，可以分为以下二种格式：

    PEM - Privacy Enhanced Mail,打开看文本格式,以"-----BEGIN..."开头, "-----END..."结尾,内容是BASE64编码.
    Apache和*NIX服务器偏向于使用这种编码格式.

    DER - Distinguished Encoding Rules,打开看是二进制格式,不可读.
    Java和Windows服务器偏向于使用这种编码格式
OpenSSL 相当于SSL的一个实现，如果把SSL规范看成OO中的接口，那么OpenSSL则认为是接口的实现。接口规范本身是安全没问题的，但是具体实现可能会有不完善的地方，比如之前的"心脏出血"漏洞，就是OpenSSL中的一个bug.

##### # 证书验证
    
    # 验证请求文件
    openssl req -verify -in server.csr -noout
    # 验证私钥
    openssl rsa -inform pem -noout -text -in server.key
    # 验证证书
    openssl x509 -noout -text -in server.crt

#### # cfssl 相关操作

具体见[点击这里](https://gitee.com/whatdy/k8s/blob/master/ssl_example/README.md) 





