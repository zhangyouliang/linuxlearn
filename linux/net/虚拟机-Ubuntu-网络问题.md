> ubuntu vm 虚拟机在本地出现的各种问题

概况
---

- Ubuntu 16.04 
- VM 网络连接情况
    - nat 网络连接 (端口转发: 127.0.0.1:2345 ===> vm:22)
    - only-host(vboxnet1: ipv4: 172.17.8.1, 子网掩码: ﻿255.255.255.0)
    - 桥架网卡(en0:Wi-Fi)
    - [三种网络区别](./README.md)
- OX 10.13.3 (17D47)

技巧
---
    
    # 设置别名便于快速登录
    alias ussh="ssh -p 2345 zhangyouliang@127.0.0.1"
    


设置静态 ip
---

Ubuntu 设置 静态ip,编辑 `/etc/network/interfaces`

    # interfaces(5) file used by ifup(8) and ifdown(8)
    auto lo
    iface lo inet loopback
    
    auto enp0s8
    iface enp0s8 inet static
    address 172.17.8.110
    netmask 255.255.255.0
    gateway 172.17.8.1   ==> 错误

重启网络

    sudo /etc/init.d/networking restart

刷新 dns 列表
    
    sudo /etc/init.d/resolvconf restart
    
查看路由表(问题路由表)

    ➜  ~ route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         172.17.8.1      0.0.0.0         UG    0      0        0 enp0s3  ==> 导致联网失败的路由
    0.0.0.0         192.168.0.1     0.0.0.0         UG    100    0        0 enp0s9
    169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 enp0s3
    172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
    172.17.8.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s3
    192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s9

排查
----
我们利用 traceroute 测试链路, 发现,首先寻找的是 `172.17.8.110`,如果联网的话,不是应该找`192.168.0.1` 的吗,问题肯定处在路由表上面了,这里我们手动删除路由表(路由表的匹配问题)

    ➜  ~ traceroute www.baidu.com
    traceroute to www.baidu.com (112.80.248.73), 30 hops max, 60 byte packets
     1  bogon (172.17.8.110)  2850.416 ms !H  2850.408 ms !H  2850.405 ms !H

修复
----


修改之后的路由表
     
     ➜  ~ route -n
     Kernel IP routing table
     Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
     0.0.0.0         10.0.2.2        0.0.0.0         UG    100    0        0 enp0s3
     0.0.0.0         192.168.6.1     0.0.0.0         UG    101    0        0 enp0s9
     10.0.2.0        0.0.0.0         255.255.255.0   U     100    0        0 enp0s3
     169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 enp0s8
     172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
     172.17.8.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s8  ==> [重要] (下面有详细介绍)
     192.168.6.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s9

## 路由表调研
---
        # 手动添加路由
        $ route add -net 0.0.0.0 netmask 0.0.0.0 gw 172.17.8.1
        $ route -n
        # 测试
        $ traceroute  www.baidu.com
        traceroute to www.baidu.com (115.239.211.112), 30 hops max, 60 byte packets
        1  172.17.8.110 (172.17.8.110)  734.893 ms !H  734.828 ms !H  734.554 ms !H
        # 删除路由
        $ route del default gw 172.17.8.1 netmask 0.0.0.0
        # 重新测试(连通成功)
        $ traceroute  -n www.baidu.com                   
        traceroute to www.baidu.com (115.239.210.27), 30 hops max, 60 byte packets
        1  10.0.2.2  0.119 ms  0.131 ms  0.177 ms
        2  * * *
        3  192.168.1.1  17.199 ms  17.158 ms  18.530 ms
        4  222.71.196.1  26.156 ms  26.057 ms  26.135 ms
        5  61.152.1.221  26.790 ms 61.152.31.145  28.546 ms 61.152.30.149  25.761 ms
        6  61.152.24.62  26.021 ms 101.95.88.106  24.879 ms 101.95.88.74  30.077 ms
        7  202.97.33.242  26.829 ms 202.97.33.222  14.230 ms 202.97.33.214  14.306 ms
        8  220.191.200.248  14.414 ms 220.191.200.238  14.718 ms 220.191.200.216  14.564 ms


### 完整正确步骤
---

/etc/network/interfaces

    # interfaces(5) file used by ifup(8) and ifdown(8)
    auto lo
    iface lo inet loopback
    
    
    auto enp0s8
    iface enp0s8 inet static
    address 172.17.8.110
    netmask 255.255.255.0
    #gateway 172.17.8.1

宿主机路由规则

    ➜  ~ netstat -nr
    Routing tables
    
    Internet:
    Destination        Gateway            Flags        Refs      Use   Netif Expire
    default            192.168.6.1        UGSc           72        0     en0
    127                127.0.0.1          UCS             0        0     lo0
    127.0.0.1          127.0.0.1          UH             24   132570     lo0
    169.254            link#8             UCS             1        0     en0
    172.17.8/24        link#19            UC              2        0 vboxnet
    172.17.8.1         a:0:27:0:0:1       UHLWI           0       34     lo0   
    172.17.8.110       8:0:27:ea:1f:94    UHLWIi          1        5 vboxnet    982  => [重点](表示一台可以通信的机器:将前往 172.17.8.110 的流量,全部打到 8:0:27:ea:1f:94 地址)

虚拟机 enp0s8 网卡情况(观察:mac 地址和 宿主机的地址是一致的)
    
    ➜  ~ ifconfig enp0s8
    enp0s8    Link encap:Ethernet  HWaddr 08:00:27:ea:1f:94  
              inet addr:172.17.8.110  Bcast:172.17.8.255  Mask:255.255.255.0
              inet6 addr: fe80::a00:27ff:feea:1f94/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:17 errors:0 dropped:0 overruns:0 frame:0
              TX packets:67 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:2211 (2.2 KB)  TX bytes:7293 (7.2 KB)    


查看路由规则

    ➜  ~ route -n                           
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         10.0.2.2        0.0.0.0         UG    100    0        0 enp0s3
    0.0.0.0         192.168.6.1     0.0.0.0         UG    101    0        0 enp0s9
    10.0.2.0        0.0.0.0         255.255.255.0   U     100    0        0 enp0s3
    169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 enp0s8
    172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
    172.17.8.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s8   ===> enp0s8 网卡对应的 路由表(没有它,即使在同一个网段,也无法正常通信)
    192.168.6.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s9

这里说明咱们可以上网的网关是`10.0.2.2`,`192.168.6.1`,这里咱们使用的是后者.
    



路由表规则(增加/删除)(不一定非要执行)
    
    # add
    route add -net 172.17.8.0/24 enp0s8
    # del
    route del -net 172.17.8.0/24
    
    # 测试代码(无视)
    # route add default netmask 0.0.0.0 gw 10.0.2.2 metric 100
    # route del default gw 10.0.2.2 netmask 0.0.0.0  
    # route add default netmask 0.0.0.0 gw 192.168.6.1 metric 100
    # route del default gw 192.168.6.1 netmask 0.0.0.0  

### 问题
----

# dns 解析慢?dns 地址不固定?
----

    # 解析速度非常慢,说明dns 有问题
    $ curl -v www.baidu.com
    $ cat /etc/resolv.conf
    nameserver 192.168.6.1
    # 永久添加dns
    $ vim /etc/resolvconf/resolv.conf.d/head
    nameserver 8.8.8.8
    # 再次测试是不是速度非常快了
    $ curl -v www.baidu.com


### 参考
---

[linux 路由表设置 之 route 指令详解](https://www.cnblogs.com/baiduboy/p/7278715.html)