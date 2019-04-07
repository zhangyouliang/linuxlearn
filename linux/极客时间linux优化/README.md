### Linux性能优化实战

性能分析:
* 选择指标评估应用程序和系统的性能
* 为应用程序和系统设置性能目标
* 进行性能基准测试
* 性能分析定位瓶颈
* 优化系统和应用程序
* 性能监控和告警



笔记
----


**负载相关**


- 模拟 cpu 密集型进程  stress -c 1 --timeout 600
- I/O 密集型进程 stress -c 1 --timeout 600
- 大量进程的场景 stress -c 8 --timeout 600


    # -P ALL 表示监控所有 CPU
    mpstat -P ALL 5 
    # 间隔 5 s 后输出一组数据
    pidstat -u 5 1
    # stress-ng 模拟大量 io 问题
    stress-ng -i 1 --hdd 1 --timeout 600

**上下文相关**

    vmstat -w 1 5 

- cs 上下文
- in 每秒中断次数
- r 正在运行和等待cpu的进程数
- b 处于不可中断睡眠状态的进程数

    # 上下文切换
    pidstat -w 5 

- cswch 自愿上下文切换
- nvcswch 非自愿上下文切换

    # 模拟 10 线程
    sysbench --num-threads=10 --max-time=300 --test=threads run 

- vmstat 1 大体查看上下文切换,和进程运行情况
- pidstat -w -u 1 详细查看 cpu 指标,以及上下文切换情况
  - pidstat -wt 1 属性结构查看上下文切换情况 **(添加 -t 属性)**

**查看系统原始文件判断终端情况**

watch -d cat /proc/interrupts

- RES 重度调度,这个中断类型表示,还清空闲状态的 CPU 类调度新的任务运行.(单核CPU 不会出现)


- 自愿上下文切换你变多,说明进程都在等待资源,可能存在 I/O 问题
- 非自愿上下文切换变多了,说明进程都在被强制调度,也就是在争夺 CPU,说明 CPU 成了瓶颈
- 中断次数多了,说明CPU 被中断处理程序占用,还可以通过查看 **/proc/interrupts** 判断具体类型


**CPU 占用居高不下**

CPU 每秒触发终端次数 grep 'CONFIG_HZ=' /boot/config-$(uname -r)

- nice 代表优先级 (-20~19)
- idle 代表空闲时间,但是不包含 I/O 的时间
- iowait 代表 I/O 的 CPU时间
- irq 硬中断
- softirq 软中断
- steal 虚拟机CPU占用时间

**底层分析**

> http://yun1991.com/linux/%E5%8A%A8%E6%80%81%E5%88%86%E6%9E%90%E5%B7%A5%E5%85%B7perf%E7%9A%84%E4%BD%BF%E7%94%A8.html


    # 查看树形结构
    perf top -g 

> 问题: (Cannot load tips.txt file, please install perf!)



https://time.geekbang.org/column/article/70476



**软中断**

    # 模拟洪水攻击
    hping3 -S -p 80 -i u100 localhost >/dev/null  2>&1  
    # 观察硬中断
    watch -d cat /proc/interrupts 
    # 观察软中断
    watch -d cat /proc/interrupts 


**怎么缓解 DDOS 攻击带来的性能下降问题**


    # 运行 Nginx 服务并对外开放 80 端口
    # --network=host 表示使用主机网络（这是为了方便后面排查问题）
    $ docker run -itd --name=nginx --network=host nginx

    # 容器查看
    docker inspect nginx -f {{.NetworkSettings.Networks.bridge.IPAddress}}

    # -w 表示只输出 HTTP 状态码及总时间，-o 表示将响应重定向到 /dev/null
    $ curl -s -w 'Http code: %{http_code}\nTotal time:%{time_total}s\n' -o /dev/null http://172.17.0.4/
    ...
    Http code: 200
    Total time:0.002s

发起 DOS 攻击

    # -S 参数表示设置 TCP 协议的 SYN（同步序列号），-p 表示目的端口为 80
    # -i u10 表示每隔 10 微秒发送一个网络帧
    $ hping3 -S -p 80 -i u100 172.17.0.4 >/dev/null  2>&1



    # --connect-timeout 表示连接超时时间
    $ curl -s -w 'Http code: %{http_code}\nTotal time:%{time_total}s\n' -o /dev/null --connect-timeout 10 http://172.17.0.4
    ...
    Http code: 000
    Total time:10.001s
    curl: (28) Connection timed out after 10000 milliseconds
