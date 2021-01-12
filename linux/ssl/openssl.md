1、非对称加密算法概述
===

非对称加密算法也称公开密钥算法，其解决了对称加密算法密钥分配的问题，非对称加密算法基本特点如下：

- 加密密钥和解密密钥不同
- 密钥对中的一个密钥可以公开
- 根据公开密钥很难推算出私人密钥

根据非对称加密算法的特点，可用户数字签名、密钥交换、数据加密。但是由于非对称加密算法较对称加密算法加密速度慢很多，故最常用的用途是数字签名和密钥交换。

目前常用的非对称加密算法有`RSA`, `DH`和`DSA`三种，但并非都可以用于密钥交换和数字签名。而是RSA可用于数字签名和密钥交换，DH算法可用于密钥交换，而DSA算法专门用户数字签名。

openssl支持以上三种算法，并为三种算法提供了丰富的指令集，本章主要介绍RSA算法及相关指令


2、RSA算法相关指令及用法
===
RSA虽然可以数字签名、密钥交换和数据加密，但是RSA加密数据速度慢，通常不使用RSA加密数据。所以最常用的功能就是数字签名和密钥交换，抛开数字签名和密钥交换的概念，实质上就是使用公钥加密还是使用私钥加密的区别。所以我们只要记住一句话：“公钥加密，私钥签名”。

公钥加密：用途是密钥交换，用户A使用用户B的公钥将少量数据加密发送给B，B用自己的私钥解密数据

私钥签名：用途是数字签名，用户A使用自己的私钥将数据的摘要信息加密一并发送给B，B用A的公钥解密摘要信息并验证

opessl中RSA算法指令主要有三个，其他指令虽有涉及，但此处不再详述。

指令	功能
genrsa	生成并输入一个RSA私钥
rsa	处理RSA密钥的格式转换等问题
rsautl	使用RSA密钥进行加密、解密、签名和验证等运算

2.1 genrsa指令说明
====

genrsa用于生成密钥对，其用法如下


````
xlzh@cmos:~$ openssl genrsa -
usage: genrsa [args] [numbits]                                                     //密钥位数，建议1024及以上
 -des            encrypt the generated key with DES in cbc mode                    //生成的密钥使用des方式进行加密
 -des3           encrypt the generated key with DES in ede cbc mode (168 bit key)  //生成的密钥使用des3方式进行加密
 -seed
                 encrypt PEM output with cbc seed                                  //生成的密钥还是要seed方式进行
 -aes128, -aes192, -aes256
                 encrypt PEM output with cbc aes                                   //生成的密钥使用aes方式进行加密
 -camellia128, -camellia192, –camellia256 
                 encrypt PEM output with cbc camellia                              //生成的密钥使用camellia方式进行加密
 -out file       output the key to 'file                                           //生成的密钥文件，可从中提取公钥
 -passout arg    output file pass phrase source                                    //指定密钥文件的加密口令，可从文件、环境变量、终端等输入
 -f4             use F4 (0x10001) for the E value                                  //选择指数e的值，默认指定该项，e值为65537 -3              use 3 for the E value                                             //选择指数e的值，默认值为65537，使用该选项则指数指定为3
 -engine e       use engine e, possibly a hardware device.                         //指定三方加密库或者硬件
 -rand file:file:...
                 load the file (or the files in the directory) into                //产生随机数的种子文件
                 the random number generator
````



可以看到`genrsa`指令使用较为简单，常用的也就有指定加密算法、输出密钥文件、加密口令。我们仅举一个例子来说明

````
/*
 * 指定密钥文件 rsa.pem
 * 指定加密算法 aes128
 * 指定加密密钥 123456
 * 指定密钥长度 1024
 **/
xlzh@cmos:~$ openssl genrsa -out rsa.pem -aes128 -passout pass:123456 1024
Generating RSA private key, 1024 bit long modulus
...............................................................++++++
.................................++++++
e is 65537 (0x10001)  // 默认模式65537
/*加密后的密钥文件有加密算法等信息*/
xlzh@cmos:~$ cat rsa.pem 
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,4C23682B0D34D339ED7E44819A70B4F9

c9uHqqWbkcw3hjdQ/6fGuJcOFchd4+KfVZoJnnISnJBAhv3CelFAksKb2RKa5GoC
4Eq6SykCCSH8OboPoPBjd1ZdAsDl1Pio0vIJfAoQ4NmaRJ61+6onJ/HAx2NFTDjN
yrmsGOWejB6A3MT4KiXrvICnkKMsUY1Qp6ln2qOeVynmxeWAWiVZnjfm0OkScL1K
RGSuL32vecN5b1S8fZTYJTS3PQxjmyaw65zLX+8mUObanL9WhSLTz2eo/6xTzRbD
iOGMolfP/3ObqIAS3007qV48CtwWrlAa+RpbMVIiESN7BforOaNbh0s5NVuUnXYs
hx90iZj2M1L4i5SP8jKBunXPK6CHQtUQXpMH06nhoMNyZPtRQegFgZlwVOpOfoS5
khGAjJPnEXI7ah8oCNYO21JV6SlMFxK1lUeS3xCvM8Cd/zVBSzD7jg+axBJr+LpO
rhpmEFkStXHtFo3OK3BoyQHIzYEYH4S59xWO+dfrb2zUvkKsQKkV+TFMSZpr7b7U
iegUcK3NrbcWDApfTYmf/edublJBv816to+hYQLhXKfuzP5iMJmjnubhrXrA6S47
7XN6nil9DGWzUEMPnH6Brc8mj7JwFtxdpWDN2pY+VcJ04O98fO08c+4eSS3u0Y9f
TyxYy1C9nIWxF+t2Dulq94N4AQ2uyTXoVNhrmDYrJ9BUCugg6zx6xtU24aSGFvtn
ikgAU8JCX0GkcwU60tTLSxPNAWhNxJSJ5n7BXaV6QQ1GOiiKQlJAcRv2PMxNqVgK
poVq742+awsichrwqE5VIFW9AdSMyIT7w06IogyUrS+0+FmFS6qPtT3ZbFZakzkd
-----END RSA PRIVATE KEY-----
xlzh@cmos:~$

````


2.2 rsa指令说明
====

rsa指令用户管理生成的密钥，其用法如下

````
xlzh@cmos:~$ openssl rsa -
unknown option -
rsa [options] <infile >outfile     
where options are
 -inform arg     input format - one of DER NET PEM                      //输入文件格式，默认pem格式
 -outform arg    output format - one of DER NET PEM                     //输入文件格式，默认pem格式
 -in arg         input file                                             //输入文件
 -sgckey         Use IIS SGC key format                                 //指定SGC编码格式，兼容老版本，不应再使用
 -passin arg     input file pass phrase source                          //指定输入文件的加密口令，可来自文件、终端、环境变量等
 -out arg        output file                                            //输出文件
 -passout arg    output file pass phrase source                         //指定输出文件的加密口令，可来自文件、终端、环境变量等
 -des            encrypt PEM output with cbc des                        //使用des加密输出的文件
 -des3           encrypt PEM output with ede cbc des using 168 bit key  //使用des3加密输出的文件
 -seed           encrypt PEM output with cbc seed                       //使用seed加密输出的文件
 -aes128, -aes192, -aes256
                 encrypt PEM output with cbc aes                        //使用aes加密输出的文件
 -camellia128, -camellia192, -camellia256
                 encrypt PEM output with cbc camellia                   //使用camellia加密输出的文件呢
 -text           print the key in text                                  //以明文形式输出各个参数值
 -noout          don't print key out                                    //不输出密钥到任何文件
 -modulus        print the RSA key modulus                              //输出模数指
 -check          verify key consistency                                 //检查输入密钥的正确性和一致性
 -pubin          expect a public key in input file                      //指定输入文件是公钥
 -pubout         output a public key                                    //指定输出文件是公钥
 -engine e       use engine e, possibly a hardware device.              //指定三方加密库或者硬件
xlzh@cmos:~$

````


rsa指令操作示例如下

1、rsa添加和去除密钥的保护口令
====

````
/*生成不加密的RSA密钥*/
xlzh@cmos:~/test$ openssl genrsa -out RSA.pem
Generating RSA private key, 512 bit long modulus
..............++++++++++++
.....++++++++++++
e is 65537 (0x10001)
/*为RSA密钥增加口令保护*/
xlzh@cmos:~/test$ openssl rsa -in RSA.pem -des3 -passout pass:123456 -out E_RSA.pem
writing RSA key
/*为RSA密钥去除口令保护*/
xlzh@cmos:~/test$ openssl rsa -in E_RSA.pem -passin pass:123456 -out P_RSA.pem
writing RSA key
/*比较原始后的RSA密钥和去除口令后的RSA密钥，是一样*/
xlzh@cmos:~/test$ diff RSA.pem P_RSA.pem
````
2、修改密钥的保护口令和算法
====
````
/*生成RSA密钥*/
xlzh@cmos:~/test$ openssl genrsa -des3 -passout pass:123456 -out RSA.pem
Generating RSA private key, 512 bit long modulus
..................++++++++++++
......................++++++++++++
e is 65537 (0x10001)
/*修改加密算法为aes128，口令是123456*/
xlzh@cmos:~/test$ openssl rsa -in RSA.pem -passin pass:123456 -aes128 -passout pass:123456 -out E_RSA.pem
writing RSA key
````
3、查看密钥对中的各个参数
====
````
xlzh@cmos:~/test$ openssl rsa -in RSA.pem -des -passin pass:123456 -text -noout
````
4、提取密钥中的公钥并打印模数值
====
````
/*提取公钥，用pubout参数指定输出为公钥*/
xlzh@cmos:~/test$ openssl rsa -in RSA.pem -passin pass:123456 -pubout -out pub.pem
writing RSA key
/*打印公钥中模数值*/
xlzh@cmos:~/test$ openssl rsa -in pub.pem -pubin -modulus -noout
Modulus=C35E0B54041D78466EAE7DE67C1DA4D26575BC1608CE6A199012E11D10ED36E2F7C651D4D8B40D93691D901E2CF4E21687E912B77DCCE069373A7F6585E946EF
````

5、转换密钥的格式
====
````
/*把pem格式转化成der格式，使用outform指定der格式*/
xlzh@cmos:~/test$ openssl rsa -in RSA.pem -passin pass:123456 -des -passout pass:123456 -outform der -out rsa.der
writing RSA key
/*把der格式转化成pem格式，使用inform指定der格式*/
xlzh@cmos:~/test$ openssl rsa -in rsa.der -inform der -passin pass:123456 -out rsa.pem
````


2.3 rsautl指令说明
====
上述两个指令是密钥的生成及管理作用，rsautl则是真正用于密钥交换和数字签名。实质上就是使用RSA公钥或者私钥加密。

而无论是使用公钥加密还是私钥加密，RSA每次能够加密的数据长度不能超过RSA密钥长度，并且根据具体的补齐方式不同输入的加密数据最大长度也不一样，而输出长度则总是跟RSA密钥长度相等。RSA不同的补齐方法对应的输入输入长度如下表

````
数据补齐方式	输入数据长度	输出数据长度	参数字符串
PKCS#1 v1.5	少于(密钥长度-11)字节	同密钥长度	-pkcs
PKCS#1 OAEP	少于(密钥长度-11)字节	同密钥长度	-oaep
PKCS#1 for SSLv23	少于(密钥长度-11)字节	同密钥长度	-ssl
不使用补齐	同密钥长度	同密钥长度	-raw
````
rsautl指令用法如下

````
xlzh@cmos:~$ openssl rsautl - 
Usage: rsautl [options]                  
-in file        input file                                           //输入文件
-out file       output file                                          //输出文件
-inkey file     input key                                            //输入的密钥
-keyform arg    private key format - default PEM                     //指定密钥格式
-pubin          input is an RSA public                               //指定输入的是RSA公钥
-certin         input is a certificate carrying an RSA public key    //指定输入的是证书文件
-ssl            use SSL v2 padding                                   //使用SSLv23的填充方式
-raw            use no padding                                       //不进行填充
-pkcs           use PKCS#1 v1.5 padding (default)                    //使用V1.5的填充方式
-oaep           use PKCS#1 OAEP                                      //使用OAEP的填充方式
-sign           sign with private key                                //使用私钥做签名
-verify         verify with public key                               //使用公钥认证签名
-encrypt        encrypt with public key                              //使用公钥加密
-decrypt        decrypt with private key                             //使用私钥解密
-hexdump        hex dump output                                      //以16进制dump输出
-engine e       use engine e, possibly a hardware device.            //指定三方库或者硬件设备
-passin arg    pass phrase source                                    //指定输入的密码
````
rsautl操作示例如下：

1、使用rsautl进行加密和解密操作
====

````
/*生成RSA密钥*/
xlzh@cmos:~/test$ openssl genrsa -des3 -passout pass:123456 -out RSA.pem 
Generating RSA private key, 512 bit long modulus
............++++++++++++
...++++++++++++
e is 65537 (0x10001)
/*提取公钥*/
xlzh@cmos:~/test$ openssl rsa -in RSA.pem -passin pass:123456 -pubout -out pub.pem 
writing RSA key
/*使用RSA作为密钥进行加密，实际上使用其中的公钥进行加密*/
xlzh@cmos:~/test$ openssl rsautl -encrypt -in plain.txt -inkey RSA.pem -passin pass:123456 -out enc.txt
/*使用RSA作为密钥进行解密，实际上使用其中的私钥进行解密*/
xlzh@cmos:~/test$ openssl rsautl -decrypt -in enc.txt -inkey RSA.pem -passin pass:123456 -out replain.txt
/*比较原始文件和解密后文件*/
xlzh@cmos:~/test$ diff plain.txt replain.txt 
/*使用公钥进行加密*/
xlzh@cmos:~/test$ openssl rsautl -encrypt -in plain.txt -inkey pub.pem -pubin -out enc1.txt
/*使用RSA作为密钥进行解密，实际上使用其中的私钥进行解密*/
xlzh@cmos:~/test$ openssl rsautl -decrypt -in enc1.txt -inkey RSA.pem -passin pass:123456 -out replain1.txt
/*比较原始文件和解密后文件*/
xlzh@cmos:~/test$ diff plain.txt replain1.txt
````
在进行这个实验的时候有个疑惑，为什么相同的明文，使用密钥加密和公钥加密后的密文结果不一样？在网上查询了下，是因为rsa公钥加密的时候根据填充模式填充随机数，导致每次加密结果不同。

2、使用rsautl进行签名和验证操作
====

````
/*提取PCKS8格式的私钥*/
xlzh@cmos:~/test$ openssl pkcs8 -topk8 -in RSA.pem -passin pass:123456 -out pri.pem -nocrypt
/*使用RSA密钥进行签名，实际上使用私钥进行加密*/
xlzh@cmos:~/test$ openssl rsautl -sign -in plain.txt -inkey RSA.pem -passin pass:123456 -out sign.txt
/*使用RSA密钥进行验证，实际上使用公钥进行解密*/
xlzh@cmos:~/test$ openssl rsautl -verify -in sign.txt -inkey RSA.pem -passin pass:123456 -out replain.txt
/*对比原始文件和签名解密后的文件*/
xlzh@cmos:~/test$ diff plain.txt replain.txt 
/*使用私钥进行签名*/
xlzh@cmos:~/test$ openssl rsautl -sign -in plain.txt -inkey pri.pem  -out sign1.txt
/*使用公钥进行验证*/
xlzh@cmos:~/test$ openssl rsautl -verify -in sign1.txt -inkey pub.pem -pubin -out replain1.txt
/*对比原始文件和签名解密后的文件*/
xlzh@cmos:~/test$ cat plain replain1.txt
````
要注意这里的签名和验证过程其本质上是加解密操作，不是标准意义上的签名和验证。标准意义上签名和验证是需要增加摘要操作的，后续文章再详细阐述。


参考
====
- [openssl 非对称加密算法RSA命令详解](https://www.cnblogs.com/gordon0918/p/5363466.html)