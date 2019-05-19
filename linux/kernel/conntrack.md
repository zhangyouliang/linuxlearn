> Netfilter conntrack  

在 `netfilter` 体系中，状态跟踪机制（conntrack）是重要的一部分。它是基于Linux系统的stateful防火墙的基础，也是NAT完成对相关包进行转换的手段。本文尝试对conntrack的机制进行分析和理解。


conntrack将信息存在内存结构中，包括IP，端口，协议类型，状态以及超时时间。
而且conntrack不仅可以对TCP这种有状态的会话进行状态跟踪，还可以对UDP进行状态跟踪。

conntrack本身并不会对包进行过滤，而是提供一种基于状态和关系的过滤依据。


五种状态
---

- NEW : NEW匹配连接的第一个包
- ESTABLISHED : ESTABLISHED 匹配连接的响应包及后续的包,在iptables状态中，只要发送并接到响应，连接就认为是ESTABLISHED的了。这个特点使iptables可以控制由谁发起的连接才可以通过，比如A与B通信，A发给B数据包属于NEW状态，B回复给A的数据包就变为ESTABLISHED状态。ICMP的错误和重定向等信息包也被看作是ESTABLISHED，只要它们是我们所发出的信息的应答。
- RELATED: 当一个连接与另一个已经是ESTABLISHED的连接有关时，这个连接就被认为是RELATED。这意味着，一个连接要想成为RELATED，必须首先有一个已经是ESTABLISHED的连接存在。当一个连接与另一个已经是ESTABLISHED的连接有关时，这个连接就被认为是RELATED。这意味着，一个连接要想成为RELATED，必须首先有一个已经是ESTABLISHED的连接存在。 
- INVALID: INVALID匹配那些无法识别或没有任何状态的数据包。这可能是由于系统内存不足或收到不属于任何已知连接的ICMP错误消息。一般情况下我们应该DROP此类状态的包。

- UNTRACKED: UNTRACKED状态比较简单，它匹配那些带有 NOTRACK 标签的数据包。需要注意的一点是，如果你在 raw 表中对某些数据包设置有 NOTRACK 标签，那上面的4种状态将无法匹配这样的数据包，因此你需要单独考虑 NOTRACK 包的放行规则。


参数
---

    # 语法
    conntrack -L [table] [options] [-z]
    conntrack -G [table] parameters
    conntrack -D [table] parameters
    conntrack -I [table] parameters
    conntrack -U [table] parameters
    conntrack -E [table] [options]
    conntrack -F [table]
    conntrack -C [table]
    conntrack -S

    # table
    conntrack: 默认表,通过系统的所有当前跟踪连接的列表
    expect: 监控,在一个连接中生成的另一个连接的连接,例如 ftp

    # OPTIONS
    # 这些选项指定要执行的特定操作。在任何给定时间只能指定其中一个。
     -L --dump
            List connection tracking or expectation table

    -G, --get
            Search for and show a particular (matching) entry in the given table.

    -D, --delete
            Delete an entry from the given table.

    -I, --create
            Create a new entry from the given table.

    -U, --update
            Update an entry from the given table.

    -E, --event
            Display a real-time event log.

    -F, --flush
            Flush the whole given table

    -C, --count
            Show the table counter.

    -S, --stats
            Show the in-kernel connection tracking system statistics.
    
    # 参数
    -z, --zero 
        只能在 -L 后面使用
    -o, --output [extended,xml,timestamp,id,ktimestamp,labels]
        输出形式
    -e, --event-mask [ALL|NEW|UPDATES|DESTROY][,...]
        只能在 "-E --event" 后面使用
    -b, --buffer-size value (in bytes)
        设置Netlink套接字缓冲区大小

    # filter 参数
    # ==> 方向的 5 元中的2元
    -s, --orig-src IP_ADDRESS
    -d, --orig-dst IP_ADDRESS
    # <== 方向的 5 元中的2元
    -r, --reply-src IP_ADDRESS
    -q, --reply-dst IP_ADDRESS
    -p, --proto PROTO
        Specify layer four (TCP, UDP, ...) protocol.
    -f, --family PROTO
        指定三层负载中的(ipv4,ipv6)协议类型,默认 ipv4,只能在 "-L --dump" 后面执行
    -t, --timeout TIMEOUT
        Specify the timeout.
    -n, --src-nat
        Filter source NAT connections.

    -g, --dst-nat
        Filter destination NAT connections.

    -j, --any-nat
        Filter any NAT connections.
        -w, --zone
        Filter by conntrack zone. See iptables CT target for more information.
    --tuple-src IP_ADDRESS
        Specify the tuple source address of an expectation.

    --tuple-dst IP_ADDRESS
        Specify the tuple destination address of an expectation.

    --mask-src IP_ADDRESS
        Specify the source address mask of an expectation.

    --mask-dst IP_ADDRESS
        Specify the destination address mask of an expectation.
    
    # PROTOCOL FILTER PARAMETERS
    # TCP-specific fields:
    --sport, --orig-port-src PORT
            Source port in original direction

    --dport, --orig-port-dst PORT
            Destination port in original direction

    --reply-port-src PORT
            Source port in reply direction

    --reply-port-dst PORT
            Destination port in reply direction
        ICMP-specific fields:

    --icmp-type TYPE
            ICMP Type. Has to be specified numerically.

    --icmp-code CODE
            ICMP Code. Has to be specified numerically.

    --icmp-id ID
            ICMP Id. Has to be specified numerically (non-mandatory)

    # UDPlite-specific fields:

    --sport, --orig-port-src PORT
            Source port in original direction

    --dport, --orig-port-dst PORT
            Destination port in original direction

    --reply-port-src PORT
            Source port in reply direction

    --reply-port-dst PORT
            Destination port in reply direction

    # SCTP-specific fields:

    --sport, --orig-port-src PORT
            Source port in original direction

    --dport, --orig-port-dst PORT
            Destination port in original direction

        --reply-port-src PORT
            Source port in reply direction

    --reply-port-dst PORT
            Destination port in reply direction

    --state [NONE | CLOSED | COOKIE_WAIT | COOKIE_ECHOED | ESTABLISHED | SHUTDOWN_SENT | SHUTDOWN_RECD | SHUTDOWN_ACK_SENT]
            SCTP state

    --orig-vtag value
            Verification tag (32-bits value) in the original direction

    --reply-vtag value
            Verification tag (32-bits value) in the reply direction

    # DCCP-specific fields (needs Linux >= 2.6.30):

    --sport, --orig-port-src PORT
            Source port in original direction

    --dport, --orig-port-dst PORT
            Destination port in original direction

    --reply-port-src PORT
            Source port in reply direction

    --reply-port-dst PORT
            Destination port in reply direction

    --state [NONE | REQUEST | RESPOND | PARTOPEN | OPEN | CLOSEREQ | CLOSING | TIMEWAIT]
            DCCP state --role [client | server] Role that the original conntrack tuple is tracking

    # GRE-specific fields:

    --srckey, --orig-key-src KEY
            Source key in original direction (in hexadecimal or decimal)
    --dstkey, --orig-key-dst KEY
            Destination key in original direction (in hexadecimal or decimal)

    --reply-key-src KEY
            Source key in reply direction (in hexadecimal or decimal)

    --reply-key-dst KEY
            Destination key in reply direction (in hexadecimal or decimal)

例子
---

    # 四层协议类型和连接数
    sudo conntrack -L -o extended | awk '{sum[$3]++} END {for(i in sum) print i, sum[i]}'

    # TCP 连接各状态对应的条数
    sudo conntrack -L -o extended | awk '/^.*tcp.*$/ {sum[$6]++} END {for(i in sum) print i, sum[i]}'

    # 三层协议类型和连接数
    sudo conntrack -L -o extended | awk '{sum[$1]++} END {for(i in sum) print i, sum[i]}'

    # 连接数最多的 10 个 IP 地址
    sudo conntrack -L -o extended | awk '{print $7}' | cut -d "=" -f 2 | sort | uniq -c | sort -nr | head -n 10

    # tcp 协议,状态为 ESTABLISHED 状态, src 为 123.174.185.155
    conntrack -L -p tcp --state ESTABLISHED -s 123.174.185.155

    # 显示 DESTROY 事件
    conntrack -E -e DESTROY
