> tcptrack 类似 iftop，使用pcap库来捕获数据包，并计算各种统计信息，比如每个连接所使用的带宽。它还支持标准的pcap过滤器，这些过滤器可用来监控特定的连接。

````shell
tcptrack -i eth0
````
