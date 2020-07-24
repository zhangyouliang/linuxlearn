mac 路由表操作
====

```bash
# 查看路由表
netstat -nr


# 查看路由表走向
route -n get www.yahoo.com
#    route to: 124.108.103.104
# destination: default
#        mask: default
#     gateway: 192.168.1.1
#   interface: en0
#       flags: <UP,GATEWAY,DONE,STATIC,PRCLONING>
#  recvpipe  sendpipe  ssthresh  rtt,msec    rttvar  hopcount      mtu     expire
#        0         0         0         0         0         0      1500         0 

route -n get 10.0.0.148
#    route to: 10.0.0.148
# destination: 10.0.0.148
#     gateway: 10.8.0.1
#   interface: utun5
#       flags: <UP,GATEWAY,HOST,DONE,WASCLONED,IFSCOPE,IFREF>
#  recvpipe  sendpipe  ssthresh  rtt,msec    rttvar  hopcount      mtu     expire
#        0         0         0         0         0         0      1402         0 


# 通过 traceroute 查看详细经过
traceroute 10.0.0.148             
# traceroute to 10.0.0.148 (10.0.0.148), 64 hops max, 52 byte packets
#  1  10.8.0.1 (10.8.0.1)  57.581 ms  32.705 ms  66.973 ms
#  2  10.42.0.1 (10.42.0.1)  9.441 ms  204.221 ms  71.786 ms
#  3  10.0.0.148 (10.0.0.148)  27.166 ms  106.821 ms  7.240 ms


```
