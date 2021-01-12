<?php
$private_key = '-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQDCbXBYtuOYrmTCGdUrWZxciamdPvjrHXXUWouNR50yCZRowon+
oeXDUZyMY/bhFtuDxTh2nQwXXGjmwyVtMq0QZoeHSsCXHDV2pwKgRzYOeMGVGDIX
eNr6KyKXvAqxN16I7XqYmfIEAnnN88FfbIyQwXkCaIWL99A0GyRbyiwMfQIDAQAB
AoGBAMEsLsVV4Mef7agUNoG9pOckN4tuN66SNLHpzGFwV7SRZAy5zJVbkYcAHQQ3
heCZ7zv6xWDEJHFJdUhhd1wJT3wQ2EguyV4sP7/mBz/EsupXHs0qJXN/UBQe62m3
CxcfYpNrXqV6XYUIGqljfcwPxPwuGFCUt7U5JPdOfIB4eSVZAkEA9F1tW4CRAdaF
i1+KsHRkyms7NwW9AK/YnOz353+ODIxtTyMUCA70n28kxO07R1k6FqpASz8hMFG3
SU3ROnhJywJBAMuvUoNyxMsYVpMe5eQunDwi9N+5WT9j9c0VvKGQS4DWM4/dlrrP
hciWW/lm4n1nsQSqY3xAsWcPVSL4eYqr2dcCQGfyjiBMUmK7xFcDL1XcTTul3ayM
LlfqdXRbgSDiq6Q+4Ai33T+ITRq9BqEWYQ76r7EQfwUDN7T8LcFq7sO2g30CQCVB
PRNj45DOM8+XAC97QwJQ1n8xNJy+mM/ZIPZgIR9Ajo/K1O34VRz6O3pjkhuj4qHa
1HV+k7Qo/sZ1si1l/2MCQQC5eY2zPObdhVH9HxaidE4tiUkyvkfPyK4gr4L6Co8j
ZYcxN9fDCZNMkyf0JI0VCC1/TqziTMTYrpP7TWVLWG4j
-----END RSA PRIVATE KEY-----';

$public_key = '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCbXBYtuOYrmTCGdUrWZxciamd
PvjrHXXUWouNR50yCZRowon+oeXDUZyMY/bhFtuDxTh2nQwXXGjmwyVtMq0QZoeH
SsCXHDV2pwKgRzYOeMGVGDIXeNr6KyKXvAqxN16I7XqYmfIEAnnN88FfbIyQwXkC
aIWL99A0GyRbyiwMfQIDAQAB
-----END PUBLIC KEY-----';


//echo $private_key;
$pi_key =  openssl_pkey_get_private($private_key);//这个函数可用来判断私钥是否是可用的，可用返回资源id Resource id
$pu_key = openssl_pkey_get_public($public_key);//这个函数可用来判断公钥是否是可用的
print_r($pi_key);echo "\n";
print_r($pu_key);echo "\n";

#################################### 加密测试 ####################################

$data = "aassssasssddd";//原始数据
$encrypted = "";
$decrypted = "";

echo "source data:",$data,"\n";

echo "private key encrypt:\n";

openssl_private_encrypt($data,$encrypted,$pi_key);//私钥加密
$encrypted = base64_encode($encrypted);//加密后的内容通常含有特殊字符，需要编码转换下，在网络间通过url传输时要注意base64编码是否是url安全的
echo $encrypted,"\n";

echo "public key decrypt:\n";

openssl_public_decrypt(base64_decode($encrypted),$decrypted,$pu_key);//私钥加密的内容通过公钥可用解密出来
echo $decrypted,"\n";

echo "---------------------------------------\n";
echo "public key encrypt:\n";

openssl_public_encrypt($data,$encrypted,$pu_key);//公钥加密
$encrypted = base64_encode($encrypted);
echo $encrypted,"\n";

echo "private key decrypt:\n";
openssl_private_decrypt(base64_decode($encrypted),$decrypted,$pi_key);//私钥解密
echo $decrypted,"\n";
