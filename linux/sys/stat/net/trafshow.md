> 与netwatch和pktstat一样，trafshow也可以报告当前活动连接、它们使用的协议以及每条连接上的数据传输速度。它能使用pcap类型过滤器，对连接进行过滤。

````
# 只监控TCP连接
trafshow -i eth0 tcp
# 交互界面 
trafshow


Interface                                  Address                                                                                                                        Description
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
eth0                                       0:16:3e:c:dd:77  172.18.0.156                                                                                                  Ethernet                                               
docker0                                    2:42:9d:bc:6b:7e  172.17.0.1 10.42.0.1                                                                                         Ethernet
vethdd644ca                                1a:6c:64:ad:10:87                                                                                                              Ethernet
vethra434bd79e0                            66:72:a3:cb:ab:61                                                                                                              Ethernet
veth46d8caa                                8e:ba:a9:b6:a8:a0                                                                                                              Ethernet
vethr25e20aa4ff                            d2:5a:8f:10:db:e                                                                                                               Ethernet
vethrdac55b7f4b                            2:3b:4c:cc:3:c6                                                                                                                Ethernet
vethr7201b81ef4                            86:78:f9:ff:52:70                                                                                                              Ethernet
vethr2c502be0c4                            d6:84:a9:8:c:d0                                                                                                                Ethernet
vethr90c26207b5                            22:24:e:b8:b5:e8                                                                                                               Ethernet
vethr6a79548cc6                            e2:34:7a:af:33:c8                                                                                                              Ethernet
vethr28d74923e7                            5a:b1:a2:98:9f:5f                                                                                                              Ethernet
vethrc71de8fe8f                            7a:e8:2d:df:9c:67                                                                                                              Ethernet
vethr294d309e09                            9e:a9:2f:93:c8:25                                                                                                              Ethernet
vethr5018564c15                            46:51:ef:b0:5:ea                                                                                                               Ethernet
vethrc015c16e17                            26:7b:24:e2:87:a5                                                                                                              Ethernet
vethr422772a886                            26:e7:a6:85:95:6e                                                                                                              Ethernet
vethr22464e3550                            f2:73:60:aa:c5:5b                                                                                                              Ethernet
vethrf84cdd7931                            ce:98:e9:2a:d8:3b                                                                                                              Ethernet
lo                                         127.0.0.1                                                                                                                      Loopback

````
