> ubuntu vm 虚拟机,这是静态ip之后,内网可以发送 icmp 请求,但是无法接收数据问题(也就是ping,无法显示结果,但是dns 解析正常)

概况
---

- Ubuntu 16.04 
- VM 网络连接情况
    - nat 网络连接 (端口转发: 127.0.0.1:2345 ===> vm:22)
    - only-host(vboxnet1: ipv4: 172.17.8.1, 子网掩码: ﻿255.255.255.0)
    - 桥架网卡(en0:Wi-Fi)
    - [三种网络区别](./README.md)
- OX 10.13.3 (17D47)



设置静态 ip
---

Ubuntu 设置 静态ip,编辑 `/etc/network/interfaces`

    # interfaces(5) file used by ifup(8) and ifdown(8)
    # auto lo
    #iface lo inet loopback
    
    auto enp0s3
    iface enp0s3 inet static
    address 172.17.8.110
    netmask 255.255.255.0
    gateway 172.17.8.1

重启网络

    sudo /etc/init.d/networking restart

刷新 dns 列表
    
    sudo /etc/init.d/resolvconf restart
    
查看路由表(问题路由表)

    ➜  ~ route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         172.17.8.1      0.0.0.0         UG    0      0        0 enp0s3
    0.0.0.0         192.168.0.1     0.0.0.0         UG    100    0        0 enp0s9
    169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 enp0s3
    172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
    172.17.8.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s3
    192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s9

排查
----
我们利用 traceroute 测试链路, 发现,首先寻找的是 `172.17.8.110`,如果联网的话,不是应该找`192.168.0.1` 的吗,问题肯定处在路由表上面了,这里我们手动删除路由表

    ➜  ~ traceroute www.baidu.com
    traceroute to www.baidu.com (112.80.248.73), 30 hops max, 60 byte packets
     1  bogon (172.17.8.110)  2850.416 ms !H  2850.408 ms !H  2850.405 ms !H

测试(手动测试路由表的影响)
---
    # 手动添加路由
    route add -net 0.0.0.0 netmask 0.0.0.0 gw 172.17.8.1
    # route -n
    # 测试
    traceroute  www.baidu.com
    traceroute to www.baidu.com (115.239.211.112), 30 hops max, 60 byte packets
     1  172.17.8.110 (172.17.8.110)  734.893 ms !H  734.828 ms !H  734.554 ms !H
    # 删除路由
    route del default gw 172.17.8.1 netmask 0.0.0.0
    # 重新测试(连通成功)
    ➜  ~ traceroute  -n www.baidu.com                   
    traceroute to www.baidu.com (115.239.210.27), 30 hops max, 60 byte packets
     1  192.168.0.1  4.032 ms  3.894 ms  8.309 ms
     2  61.152.3.118  14.878 ms 61.152.2.114  14.858 ms 61.152.3.114  16.568 ms
     3  61.152.2.113  15.687 ms  16.042 ms 61.152.2.117  18.706 ms


修复
----


修改之后的路由表
     
     ➜  ~ route -n
     Kernel IP routing table
     Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
     0.0.0.0         192.168.0.1     0.0.0.0         UG    100    0        0 enp0s9
     169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 enp0s3
     172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
     172.17.8.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s3
     192.168.0.0     0.0.0.0         255.255.255.0   U     100    0        0 enp0s9



### 参考

[linux 路由表设置 之 route 指令详解](https://www.cnblogs.com/baiduboy/p/7278715.html)