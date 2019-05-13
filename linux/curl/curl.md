> curl: 网络请求与发送命令

> [参考](http://man.linuxde.net/curl)

参数:

    -A/--user-agent <string>	设置用户代理发送给服务器
    -b/--cookie <name=string/file>	cookie字符串或文件读取位置
    --basic	使用HTTP基本验证
    -c/--cookie-jar <file>	操作结束后把cookie写入到这个文件中
    -d/--data <data>	HTTP POST方式传送数据
    -D/--dump-header <file>	把header信息写入到该文件中
    -e/--referer	来源网址
    -G/--get	以get的方式来发送数据
    -H/--header <line>	自定义头信息传递给服务器
    -i/--include	输出时包括protocol头信息
    -I/--head	只显示请求头信息
    -s，可以去除统计信息
    -v 查看解析过程


    -o/--output	把输出写到该文件中
    -u/--user <user[:password]>	设置服务器的用户和密码
    -x/--proxy <host[:port]>	在给定的端口上使用HTTP代理
    -X/--request <command>	指定什么命令
    -w , --write-out 


例子:
----

    # post 带着请求头,post body并且显示protocol头信息
    curl -i -X POST -H "'Content-type':'application/json'" -d "app_id=1325997595&idfa=53B9A1CA-72F1-46E2-89C2-969120929E95&ip=127.0.0.1&source=hcc" https://api.cusfox.com/v1/app-promote/check

    # mac 专有命令 dtruss
    sudo dtruss curl https://www.baidu.com
    # curl分析HTTPS请求时间
    # HTTPs耗时 = TCP握手 + SSL握手, 因为涉及到一些加密，及多了几次握手交互，可以看到的时要多于平常时间的3-5倍，当然这个和机器性能相关。
    curl -w "TCP handshake: %{time_connect}, SSL handshake: %{time_appconnect}\n" -so /dev/null https://www.baidu.com

    # curl –trace 命令 可以记录请求的详情
    curl -kv -1 --trace temp.txt 'https://www.baidu.com'


curl 测试解析过程

参数:

    time_namelookup ：DNS 域名解析的时候，就是把 https://zhihu.com 转换成 ip 地址的过程
    time_connect ：TCP 连接建立的时间，就是三次握手的时间
    time_appconnect ：SSL/SSH 等上层协议建立连接的时间，比如 connect/handshake 的时间
    time_redirect ：从开始到最后一个请求事务的时间
    time_pretransfer ：从请求开始到响应开始传输的时间
    time_starttransfer ：从请求开始到第一个字节将要传输的时间
    time_total ：这次请求花费的全部时间

测试

    # 测试 http 
    curl -w "@curl-fromat.txt" -o /dev/null -s -L "http://www.baidu.com"
    time_namelookup: 0.012  
    time_connect: 0.227  
    time_appconnect: 0.000  
    time_redirect: 0.000  
    time_pretransfer: 0.227  
    time_starttransfer: 0.443  
    ----------  
    time_total: 0.867 

    DNS 查询：12ms
    TCP 连接时间：pretransfter(227) - namelookup(12) = 215ms
    服务器处理时间：starttransfter(443) - pretransfer(227) = 216ms
    内容传输时间：total(867) - starttransfer(443) = 424ms


-w: 从文件中读取要打印的信息格式

-o /dev/null : 把响应的内容丢弃,因为我们不关心内容

-s: 不打印进度条



来个比较复杂的，访问某度首页，带有中间有重定向和 SSL 协议：

    ➜ ~ curl -w "@curl-format.txt" -o /dev/null -s -L "https://baidu.com"  
    time_namelookup: 0.012  
    time_connect: 0.018  
    time_appconnect: 0.328  
    time_redirect: 0.356  
    time_pretransfer: 0.018  
    time_starttransfer: 0.027  
    ----------  
    time_total: 0.384 

可以看到 `time_appconnect` 和 `time_redirect` 都不是 0 了，其中 SSL 协议处理时间为 `328-18=310ms` 。而且 `pretransfer` 和 `starttransfer` 的时间都缩短了，这是重定向之后请求的时间。


测试 100 次,并且显示请求时间

    for i in `seq 100`;do  
       time curl -s 127.0.0.1 -o /dev/null -w "http_code:%{http_code}:%{time_total}s\n"
    done






















