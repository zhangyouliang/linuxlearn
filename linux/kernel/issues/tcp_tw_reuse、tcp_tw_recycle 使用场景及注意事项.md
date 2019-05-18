linux TIME_WAIT 相关参数:

    net.ipv4.tcp_tw_reuse = 0    表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭
    net.ipv4.tcp_tw_recycle = 0  表示开启TCP连接中 TIME-WAIT sockets的快速回收，默认为0，表示关闭
    net.ipv4.tcp_fin_timeout = 60  表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间

注意：

- 不像 Windows 可以修改注册表修改2MSL 的值，linux 需要修改内核宏定义重新编译，tcp_fin_timeout 不是2MSL 而是Fin-WAIT-2状态超时时间.

- tcp_tw_reuse 和 SO_REUSEADDR 是两个完全不同的东西

   SO_REUSEADDR 允许同时绑定 127.0.0.1 和 0.0.0.0 同一个端口； SO_RESUSEPORT linux 3.7 才支持，用于绑定相同ip:port，像nginx 那样 fork方式也能实现

 

1. tw_reuse，tw_recycle 必须在客户端和服务端 timestamps 开启时才管用（默认打开）

2. tw_reuse 只对客户端起作用，开启后客户端在1s内回收

3. tw_recycle 对客户端和服务器同时起作用，开启后在 3.5*RTO 内回收，RTO 200ms~ 120s 具体时间视网络状况。

　　内网状况比tw_reuse 稍快，公网尤其移动网络大多要比tw_reuse 慢，优点就是能够回收服务端的TIME_WAIT数量

 

**对于客户端**

1. 作为客户端因为有端口65535问题，TIME_OUT过多直接影响处理能力，打开tw_reuse 即可解决，不建议同时打开tw_recycle，帮助不大；

2. tw_reuse 帮助客户端1s完成连接回收，基本可实现单机6w/s短连接请求，需要再高就增加IP数量；

3. 如果内网压测场景，且客户端不需要接收连接，同时 tw_recycle 会有一点点好处；

4. 业务上也可以设计由服务端主动关闭连接。

 

**对于服务端**


1. 打开tw_reuse无效

2. 线上环境 tw_recycle 不建议打开

   服务器处于NAT 负载后，或者客户端处于NAT后（基本公司家庭网络基本都走NAT）；

　公网服务打开就可能造成部分连接失败，内网的话到时可以视情况打开；

   像我所在公司对外服务都放在负载后面，负载会把 timestamp 都给清空，就算你打开也不起作用。

3. 服务器TIME_WAIT 高怎么办

   不像客户端有端口限制，处理大量TIME_WAIT Linux已经优化很好了，每个处于TIME_WAIT 状态下连接内存消耗很少，

而且也能通过tcp_max_tw_buckets = 262144 配置最大上限，现代机器一般也不缺这点内存。

    下面像我们一台每秒峰值1w请求的 http 短连接服务，长期处于tw_buckets 溢出状态，

tw_socket_TCP 占用70M, 因为业务简单服务占用CPU 200% 运行很稳定。


    slabtop

    262230 251461  95%    0.25K  17482       15     69928K tw_sock_TCP

    ss -s
    Total: 259 (kernel 494)
    TCP:   262419 (estab 113, closed 262143, orphaned 156, synrecv 0, timewait 262143/0), ports 80

    Transport Total     IP        IPv6
    *         494       -         -        
    RAW       1         1         0        
    UDP       0         0         0        
    TCP       276       276       0        
    INET      277       277       0        
    FRAG      0         0         0    

唯一不爽的就是：

系统日志中overflow 错误一直再刷屏，也许该buckets 调大一下了

    TCP: time wait bucket table overflow
    TCP: time wait bucket table overflow
    TCP: time wait bucket table overflow
    TCP: time wait bucket table overflow
    TCP: time wait bucket table overflow

 

1. 业务上也可以设计由客户端主动关闭连接

 

**原理分析**


 1. MSL 由来

　　发起连接关闭方回复最后一个fin 的ack，为避免对方ack 收不到、重发的或还在中间路由上的fin 把新连接给丢掉了，等个2MSL（linux 默认2min）。

　　也就是连接有谁关闭的那一方有time_wait问题，被关那方无此问题。

2. reuse、recycle

     通过timestamp的递增性来区分是否新连接，新连接的timestamp更大，那么保证小的timestamp的 fin 不会fin掉新连接，不用等2MSL。

3. reuse

     通过timestamp 递增性，客户端、服务器能够处理outofbind fin包

4. recycle

    对于服务端，同一个src ip，可能会是NAT后很多机器，这些机器timestamp递增性无可保证，服务器会拒绝非递增请求连接。

