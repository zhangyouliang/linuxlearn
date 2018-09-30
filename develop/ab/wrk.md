wrk
----
> 一般线程数不宜过多. 核数的2到4倍足够，wrk 不是使用每个连接一个线程的模型, 而是通过异步网络 io 提升并发量. 所以网络通信不会阻塞线程执行

参考:  https://www.jianshu.com/p/cf0853226dc6



    使用方法: wrk <选项> <被测HTTP服务的URL>                            
      Options:                                            
        -c, --connections <N>  跟服务器建立并保持的TCP连接数量  
        -d, --duration    <T>  压测时间           
        -t, --threads     <N>  使用多少个线程进行压测   
                                                          
        -s, --script      <S>  指定Lua脚本路径       
        -H, --header      <H>  为每一个HTTP请求添加HTTP头      
            --latency          在压测结束后，打印延迟统计信息   
            --timeout     <T>  超时时间     
        -v, --version          打印正在使用的wrk的详细版本信息
                                                          
      <N>代表数字参数，支持国际单位 (1k, 1M, 1G)
      <T>代表时间参数，支持时间单位 (2s, 2m, 2h)
      
      线程统计分析
      项目	名称	说明
      Avg	平均值	每次测试的平均值
      Stdev	标准偏差	结果的离散程度，越高说明越不稳定
      Max	最大值	最大的一次结果
      +/- Stdev	正负一个标准差占比	结果的离散程度，越大越不稳定
      Latency: 可以理解为响应时间
      Req/Sec: 每个线程每秒钟的完成的请求数
      
      一般我们来说我们主要关注平均值和最大值.
      标准差如果太大说明样本本身离散程度比较高. 有可能系统性能波动很大
      
      作者：木猫尾巴
      链接：https://www.jianshu.com/p/cf0853226dc6
      來源：简书
      简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
        
        
        
例子: 

    ➜  ~ wrk -t12 -c400 -d30s --latency http://127.0.0.1:4002
    Running 30s test @ http://127.0.0.1:4002
      12 threads and 400 connections
      Thread Stats   Avg      Stdev     Max   +/- Stdev
        Latency    57.16ms    8.04ms 347.28ms   86.64%
        Req/Sec   579.99     62.82     1.83k    83.56%
      Latency Distribution
         50%   56.19ms
         75%   60.02ms
         90%   64.26ms
         99%   87.83ms
      208017 requests in 30.09s, 40.66MB read
    Requests/sec:   6913.20
    Transfer/sec:      1.35MB

平均1s 处理 6913.20 个请求


    # 使用 l.lua 脚本进行测试
    # 这样就是模拟 4 个线程，2000 个连接，在 10s 内，间隔5s 执行 post.lua 的请求
    wrk -t4 -c2000 -d10s -T5s --script=l.lua --latency http://localhost:4002