> ifconfig 


**设置网卡多个 ip**


    ifconfig eth0 192.168.6.99 netmask 255.255.255.0 up

- eth0   //机器的第一个网卡，有些机器有多个网卡，eth1、eth2...
- 192.168.6.99   //设置网卡的静态ip地址
- netmask 255.255.255.0   //ip地址的子网掩码，无需多解释
- up   //表示立即激活该网卡

设置网卡的ip别名

    #ifconfig eth0:0 192.168.6.100 netmask 255.255.255.0 up
    #ifconfig eth0:1 173.173.173.173 netmask 255.255.255.0 up
    #ifconfig eth0:2 119.110.120.1 netmask 255.255.255.0 up
    ......

- eth0:x                    //虚拟网络接口，建立在eth0上，取值范围0-255
- 192.168.6.xxx      //增加ip别名，想加多少就加多少～～


清除ip别名


    ifconfg eth0:0 down
    ifconfg eth0:1 down
    ifconfg eth0:2 down


参考
----
- [llinux下一个网卡配置多个ip【虚拟ip】](https://www.cnblogs.com/wanghuaijun/p/6155832.html)