10 | 案例篇：系统的软中断CPU使用率升高，我该怎么办？
---

中断事件会触发中断处理程序,而中断处理程序被分为上半部分和下半部分

- 山半部分对应`硬终端`,用来快速处理中断
- 下半部分对应软终端用来异步处理上半部未完成的工作

Linux 中的软终端包括网络收发,定时,调度,PCU 锁等各种类型,可以查看 proc 文件系统中的 `/proc/softirqs`,观察软中断的运行情况.

在 Linux 中,每个 CPU 都对应一个软中断内核线程,名字是 `ksoftirqd/CPU` 编号,当软中断的频率比较高的时候,内核线程也会因为 CPU 的使用率高而导致软中断处理不及时,进而引起网络收发延迟,调度缓慢等性能问题.


工具
---
- sar 是一个 系统活动报告工具,可以实时查看网络的当前活动
- hping3 可以构造 TCP/IP 协议数据包的工具,可以对系统进行安全审计,防火墙测试等
- tcpdump 常用的网络抓包工具



        docker run -itd --name=nginx -p 8888:80 nginx
        DOCKER_IP=$(docker inspect ec497b -f {{.NetworkSettings.Networks.bridge.IPAddress}})
        curl $DOCKER_IP
        # -S 参数表示设置 TCP 协议的 SYN（同步序列号），-p 表示目的端口为 80
        # -i u100 表示每隔 100 微秒发送一个网络帧
        # 注：如果你在实践过程中现象不明显，可以尝试把 100 调小，比如调成 10 甚至 1
        $ hping3 -S -p 80 -i u100 192.168.0.30

top 发现负载,CPU占用都非常低,但是系统非常慢...

观察 `/proc/softirqs` 文件的变化

        $ watch -d cat /proc/softirqs
                    CPU0       CPU1
        HI:          0          0
        TIMER:    1083906    2368646
        NET_TX:         53          9
        NET_RX:    1550643    1916776
        BLOCK:          0          0
        IRQ_POLL:          0          0
        TASKLET:     333637       3930
        SCHED:     963675    2293171
        HRTIMER:          0          0
            RCU:    1542111    1590625

分别表示: TIMER(定时中断),NEX_TX(网络接收),SCHED(内核调度),RCU(RCU锁)等.

当然我们可以使用`sar` 工具进行观察

        # -n DEV 表示显示网络收发的报告，间隔 1 秒输出一组数据
        $ sar -n DEV 1
        Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
        Average:           lo      0.97      0.97      0.08      0.08      0.00      0.00      0.00      0.00
        Average:    br-fa7795631577      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
        Average:    br-0211271c0b99      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
        Average:    veth4b63678      0.60      1.17      0.14      0.11      0.00      0.00      0.00      0.00
        Average:    vethdc0ba8a      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
        Average:    br-581f3d791fd0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
        Average:      docker0   1674.37   3348.60     72.06    176.63      0.00      0.00      0.00      0.00
        Average:    veth51400ed   1673.77   3347.43     94.81    176.52      0.00      0.00      0.00      0.01
        Average:         eth0     10.84      9.39      0.88      3.75      0.00      0.00      0.00      0.00


- rxpck,txpck 分别表示每秒接收,发送的网络帧数,也就是PPS
- rxkb,txkb 分别表示每秒接收,发送的字节数,也就是BPS

