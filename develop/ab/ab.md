ab 测试

    ➜  ~ ab -n 20000 -c 20000  http://localhost:4002/ 
    This is ApacheBench, Version 2.3 <$Revision: 1706008 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/
    
    Benchmarking localhost (be patient)
    Completed 2000 requests
    Completed 4000 requests
    Completed 6000 requests
    Completed 8000 requests
    Completed 10000 requests
    Completed 12000 requests
    Completed 14000 requests
    Completed 16000 requests
    Completed 18000 requests
    Completed 20000 requests
    Finished 20000 requests
    
    
    Server Software:        nginx
    Server Hostname:        localhost
    Server Port:            4002
    
    Document Path:          /
    Document Length:        9 bytes
    
    Concurrency Level:      20000
    Time taken for tests:   5.412 seconds
    Complete requests:      20000
    Failed requests:        0
    Total transferred:      3240000 bytes
    HTML transferred:       180000 bytes
    Requests per second:    3695.18 [#/sec] (mean)
    Time per request:       5412.457 [ms] (mean)
    Time per request:       0.271 [ms] (mean, across all concurrent requests)
    Transfer rate:          584.59 [Kbytes/sec] received
    
    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:      479  970 277.7    977    1436
    Processing:   454 2112 823.5   2152    3510
    Waiting:      449 2112 823.6   2152    3510
    Total:       1865 3082 600.4   3199    4078
    
    Percentage of the requests served within a certain time (ms)
      50%   3199
      66%   3414
      75%   3525
      80%   3618
      90%   3884
      95%   4020
      98%   4042
      99%   4049
     100%   4078 (longest request)

2w 并发,2w 链接数量: 5.412 s 完成 


    ab -n 1000 -c 100 http://www.baidu.com
    其中－n表示请求数，－c表示并发数
    
    用户平均请求等待时间（Time per request）
    计算公式：处理完成所有请求数所花费的时间/ （总请求数 / 并发用户数），即
    Time per request = Time taken for tests /（ Complete requests / Concurrency Level）
    
    服务器平均请求等待时间（Time per request: across all concurrent requests）
    计算公式：处理完成所有请求数所花费的时间 / 总请求数，即
    Time taken for / testsComplete requests
    可以看到，它也=用户平均请求等待时间/并发用户数，即
    Time per request / Concurrency Level
    同时，它也是吞吐率的倒数。
    
    根据计算公式，可知 用户平均请求等待时间 = 服务器平均请求等待时间  *  并发数
    这里你的并发是-c100，所以27.3=0.273100*100

案例:
---

性能测试
- php7.2.5
- 纯 php 文件
- 内网测试
- ubuntu 16.04 2核4G

        # 测试语句
        ab -n 10000 -c 100 http://localhost:4002/

        并发:100 次数:1W
        结果:1.6S  (1.598, 1.652, 1.782)
        估算处理数:6250次/秒  (6257, 6053, 5611)

        并发:5000 次数:5000 
        结果:1S  (0.953, 0.975, 0.988)
        估算处理数:5000次/秒  (5246, 5128, 5060)


        完成时间:238S
        ab: CPU:90% 内存:53%
        进程占用:2-4进程 (主要2线程)
        CPU占用率: 90%  89%  
        内存占用:53.2-53.2 (基本没变化)







