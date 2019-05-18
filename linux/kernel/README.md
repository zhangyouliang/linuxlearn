#### 内核相关参数

> sysctl -p 让临时修改的内核参数生效

    net.ipv4.tcp_tw_reuse = 0    表示开启重用。允许将 TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭
    net.ipv4.tcp_tw_recycle = 0  表示开启TCP连接中 TIME-WAIT sockets 的快速回收，默认为0，表示关闭
    net.ipv4.tcp_fin_timeout = 60  表示如果套接字由本端要求关闭，这个参数决定了它保持在 FIN-WAIT-2 状态的时间


服务端存在 nat 网络不要开启 `net.ipv4.tcp_tw_reuse` 和`net.ipv4.tcp_tw_recycle`,特别是后者,开启将当导致 nat 网络不稳定


作为 Client 如果出现大量 TIME_WAIT 或者 端口不够用,可以使用一下优化

    net.ipv4.ip_local_port_range = 9000 65535 # 默认值范围较小 (9000~65535)
    net.ipv4.tcp_max_tw_buckets = 10000 # 默认值较小，还可适当调小
    net.ipv4.tcp_tw_reuse = 1 
    net.ipv4.tcp_fin_timeout = 10 
