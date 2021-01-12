<?php
$private_key = '-----BEGIN PRIVATE KEY-----
MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANgtSvP3kje8LCHC
wxNNFb1Sj8K8buRVQi7zqzLh2i8sQDssLF48o98KzdM80GoZeGzs/FkOv7PeqnZZ
s94Jm/yZheZhVuLJBrTyJd2ADE9KTtgApmtnioqbJpoEDPXfjAcIMFk+viZT+G92
0iLA1VBgBVLGs1Fxufvqs1gHiBOZAgMBAAECgYAPfx+yYXrv1+NqACYvygTW74Yy
tYNVhu8ZoooRObOEUi3AkCgWEU7F/GZI0EE4ed7yIALu92myoTGjDkcgkZvG3AHO
QbUvObdFZhvEXScvNFqU14eSHr1D7U+4pdO6y9O38eEbmZwNEbHPNU2yhNxswjQy
oqKlV+473UwoW39ZIQJBAPzRkOa67d7P6gbvPvGPWaISpulbOCM0OSw40oWCTX01
FgJ5jRtL8mOGQo9VtAxvENKGiNxjN54xMvrRUUZQtI0CQQDa5bBJtNzjwcsrquDE
kW3H9fEcuGt8K3OfVhPqae3Uhnhmisv9igh4FNZPu6boxMHAqjofNWa8j+FEBCgf
SMY9AkEAvm7Im9OQG3Y3DLQnkGLvHDK6gSoR1gqfSh0fDivBXJ+hDYorbLU/RhI6
jqb6sSbz3/AwpPkjSsg6Y01J0BI4fQJAKCXAc4RMjylYDiZFG0hhDi+5jT7118xQ
ZITxGilbiYMwSf5i85mBfCS2OeF892w+7QtLpbWxphvtgQASK8q5MQJAEhqRnEpC
RYjrFanu8A6QT94DiZUqKjrAkn9veEigqwTi3uxgzmsG0U6fCO9jK0hf9HUgYnuQ
EN8Yvr3hr4FnVw==
-----END PRIVATE KEY-----';

$public_key = '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDYLUrz95I3vCwhwsMTTRW9Uo/C
vG7kVUIu86sy4dovLEA7LCxePKPfCs3TPNBqGXhs7PxZDr+z3qp2WbPeCZv8mYXm
YVbiyQa08iXdgAxPSk7YAKZrZ4qKmyaaBAz134wHCDBZPr4mU/hvdtIiwNVQYAVS
xrNRcbn76rNYB4gTmQIDAQAB
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
