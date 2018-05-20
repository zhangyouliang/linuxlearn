> skill命令用于向选定的进程发送信号，冻结进程。这个命令初学者并不常用，深入之后牵涉到系统服务优化之后可能会用到。


语法
---

    skill(选项)
    
选项
----
    -f：快速模式；
    -i：交互模式，每一步操作都需要确认；
    -v：冗余模式；
    -w：激活模式；
    -V：显示版本号；
    -t：指定开启进程的终端号；
    -u：指定开启进程的用户；
    -p：指定进程的id号；
    -c：指定开启进程的指令名称。
    
实例
---

如果您发现了一个占用大量CPU和内存的进程，但又不想停止它，该怎么办？考虑下面的top命令输出：

    top -c -p 16514
    23:00:44  up 12 days,  2:04,  4 users,  load average: 0.47, 0.35, 0.31
    1 processes: 1 sleeping, 0 running, 0 zombie, 0 stopped
    CPU states:  cpu    user    nice  system    irq  softirq  iowait    idle
               total    0.0%    0.6%    8.7%   2.2%     0.0%   88.3%    0.0%
    Mem:  1026912k av, 1010476k used,   16436k free,       0k shrd,   52128k buff
                        766724k actv,  143128k in_d,   14264k in_c
    Swap: 2041192k av,   83160k used, 1958032k free                  799432k cached
     
      PID USER     PRI  NI  SIZE  RSS SHARE stat %CPU %MEM   time CPU command
    16514 oracle    19   4 28796  26M 20252 D N   7.0  2.5   0:03   0 oraclePRODB2...

既然您确认进程16514占用了大量内存，您就可以使用skill命令“冻结”它，而不是停止它。

    skill -STOP 1
    
    # 恢复 
    skill -CONT 16514
    $ 停止
    skill -STOP oracle
    