> tcpdump命令是一款sniffer工具，它可以打印所有经过网络接口的数据包的头信息，也可以使用-w选项将数据包保存到文件中，方便以后分析。

> [参考:超级详细Tcpdump 的用法](https://www.cnblogs.com/maifengqiang/p/3863168.html)

语法
---
    tcpdump(选项)
选项
---
    -a：尝试将网络和广播地址转换成名称；
    -A 用ASCII码和hex来展示包的内容，和上面的－A比较像。－XX可以展示更多的信息（比如link layer的header）。
    -c<数据包数目>：收到指定的数据包数目后，就停止进行倾倒操作；
    -d：把编译过的数据包编码转换成可阅读的格式，并倾倒到标准输出；
    -dd：把编译过的数据包编码转换成C语言的格式，并倾倒到标准输出；
    -ddd：把编译过的数据包编码转换成十进制数字的格式，并倾倒到标准输出；
    -e：在每列倾倒资料上显示连接层级的文件头；
    -f：用数字显示网际网络地址；
    -D：列出可用于抓包的接口。将会列出接口的数值编号和接口名，它们都可以用于"-i"后。
    -F<表达文件>：从文件中读取抓包的表达式。若使用该选项，则命令行中给定的其他表达式都将失效。
    -i<网络界面>：使用指定的网络截面送出数据包；
    -l：使用标准输出列的缓冲区；
    -n：不把主机的网络地址转换成名字；
    -nn：除了-n的作用外，还把端口显示为数值，否则显示端口服务名
    -N：不列出域名；
    -O：不将数据包编码最佳化；
    -p：不让网络界面进入混杂模式；
    -q ：快速输出，仅列出少数的传输协议信息；
    -r<数据包文件>：从指定的文件读取数据包数据；
    -s<数据包大小>：设置每个数据包的大小,默认情况下tcpdump会展示96字节的长度，要获取完整的长度可以用-s0或者-s1600；
    -S：用绝对而非相对数值列出TCP关联数；
    -t：在每列倾倒资料上不显示时间戳记；
    -tt： 在每列倾倒资料上显示未经格式化的时间戳记；
    -T<数据包类型>：强制将表达方式所指定的数据包转译成设置的数据包类型；
    -v：详细显示指令执行过程；
    -vv：更详细显示指令执行过程；
    -x：用十六进制字码列出数据包资料；
    -w<数据包文件>：把数据包数据写入指定的文件。

    src: 指明ip包的发送方地址
    dst: 指明ip包的接收方地址
    port: 指明tcp包发送方或者接收方的端口号
    and,or,not,操作法，字面意思

常用例子:

    tcpdump 'tcp[13] & 16!=0'
    tcpdump src port 80 and tcp
    tcpdump -vv src baidu and not dst port 23

    # 不解析端口和服务名,并且展示 tcp关联数量,以及详细过程
    tcpdump -nnvvS src 192.0.1.100 and dst port 443

    ## 使用标准输出列的缓冲区,例如更多信息
    tcpdump -i docker0 -AAl src 60.28.215.123 or dst 60.28.215.123

实例
----

直接启动tcpdump将监视第一个网络接口上所有流过的数据包


    # 监听 docker0 网卡,获取 http中的 GET,POST 请求(GET: 16 进制为 47455420, POST: 504f5354)
    tcpdump -nn -i docker0 'tcp[32:4] = 0x47455420 or tcp[32:4] = 0x504f5354' 

    # -l 行缓冲 标准输出. 可用于 捕捉 数据 的 同时 查看 数据. 例如
    # 将结果导入到 dat ,并且展示在屏幕上
    tcpdump -l | tee dat
    或者
    tcpdump  -l   > dat  &  tail  -f  dat

    # 主机过滤
    tcpdump -i docker0 host 192.168.0.101
    # 源主机地址
    tcpdump -i docker0 src host 192.168.0.101
    # 目标主机地址
    tcpdump -i docker0 dst host 192.168.0.101
    # 截获主机192.168.1.101 和主机192.168.1.102 或192.168.1.103的通信
    tcpdump -i docker0 host 192.168.1.101 and (192.168.1.102 or 192.168.1.103 )
    # 获取主机 192.168.1.101 除了和主机192.168.1.102 之外所有主机通信的ip包
    tcpdump ip host 192.168.1.101 and !192.168.1.102
    # 端口
    tcpdump -i docker0 port 22
    # 源端口
    tcpdump -i docker0 src port 22
    # 目标端口
    tcpdump -i docker0 dst port 22
    # 网络过滤
    tcpdump -i docker0 net 192.168
    tcpdump -i docker0 src net 192.168
    tcpdump -i docker0 dst net 192.168
    # 协议过滤
    tcpdump -i docker0 arp
    tcpdump -i docker0 ip
    tcpdump -i docker0 tcp
    tcpdump -i docker0 udp
    tcpdump -i docker0 icmp
    # 表达式
    非 : ! or "not" (without the quotes)
    且 : && or "and"
    或 : || or "or"

    # 高级过滤包头
    proto[x:y]          : 过滤从x字节开始的y字节数。比如ip[2:2]过滤出3、4字节（第一字节从0开始排）
    proto[x:y] & z = 0  : proto[x:y]和z的与操作为0
    proto[x:y] & z !=0  : proto[x:y]和z的与操作不为0
    proto[x:y] & z = z  : proto[x:y]和z的与操作为z
    proto[x:y] = z      : proto[x:y]等于z
参考
---
- [16进制到文本字符串的转换，在线实时转换](http://www.bejson.com/convert/ox2str/)
- [tcpdump 文档](https://manpages.debian.org/stretch/manpages-zh/tcpdump.8.zh_CN.html)
- [tcpdump高级过滤](https://www.cnblogs.com/starlion/p/9017495.html)