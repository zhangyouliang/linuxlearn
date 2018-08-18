> top: 查看linux进程内存占用情况
> [linux top命令查看内存及多核CPU的使用讲述](https://www.cnblogs.com/dragonsuc/p/5512797.html),[Linux top命令参数及使用方法详解](http://www.linuxeye.com/command/top.html) ,[Linux top命令的用法详细详解](https://www.cnblogs.com/zhoug2020/p/6336453.html)

> 可替代的工具有: htop


top命令是Linux下常用的性能分析工具，能够实时显示系统中各个进程的资源占用状况


可以直接使用top命令后，查看%MEM的内容。可以选择`按进程查看或者按用户查看`，如想查看oracle用户的进程内存使用情况的话可以使用如下的命令：

    top -u orcale
    
内容解释

    PID：进程的ID
    USER：进程所有者
    PR：进程的优先级别，越小越优先被执行
    NInice：值
    VIRT：进程占用的虚拟内存
    RES：进程占用的物理内存
    SHR：进程使用的共享内存
    S：进程的状态。S表示休眠，R表示正在运行，Z表示僵死状态，N表示该进程优先值为负数
    %CPU：进程占用CPU的使用率
    %MEM：进程使用的物理内存和总内存的百分比
    TIME+：该进程启动后占用的总的CPU时间，即占用CPU使用时间的累加值。
    COMMAND：进程启动命令名称
    

常用的命令：

    P：按%CPU使用率排行
    T：按MITE+排行
    M：按%MEM排行

其他快捷键:
    
    <Space> 立即刷新
    b 开启高亮护着关闭高亮
    x 切换高亮白色
    f或者F 从当前显示中添加或者删除项目。
    o或者O改变显示项目的顺序。
    l 切换显示平均负载和启动时间信息。
    m 切换显示内存信息。
    t 切换显示进程和CPU状态信息。
    c 切换显示命令名称和完整命令行。
   
    M 根据驻留内存大小进行排序。
    P 根据CPU使用百分比大小进行排序。
    T 根据时间/累计时间进行排序
   
    W 将当前设置写入~/.toprc文件中。这是写top配置文件的推荐方法。
    
    
    i 只显示正在运行的进程(忽略闲置和僵死进程。这是一个开关式命令。)
    
    Ctrl+L 擦除并且重写屏幕。
    
    h或者? 显示帮助画面，给出一些简短的命令总结说明。
    
    
    k 终止一个进程。系统将提示用户输入需要终止的进程PID，以及需要发送给该进程什么样的信号。一般的终止进程可以使用15信号；如果不能正常结束那就使用信号9强制结束该进程。默认值是信号15。在安全模式中此命令被屏蔽。
    r 重新安排一个进程的优先级别。系统提示用户输入需要改变的进程PID以及需要设置的进程优先级值。输入一个正值将使优先级降低，反之则可以使该进程拥有更高的优先权。默认值是10。
    s 改变两次刷新之间的延迟时间。系统将提示用户输入新的时间，单位为s。如果有小数，就换算成m s。输入0值则系统将不断刷新，默认值是5 s。需要注意的是如果设置太小的时间，很可能会引起不断刷新，从而根本来不及看清显示的情况，而且系统负载也会大大增加。
    
    1 显示多核cpu占用情况,**如果不按1，则在top视图里面显示的是所有cpu的平均值。**
    

实例
--


排序
    
    首先按
    b 开启高亮护着关闭高亮
    x 切换高亮白色
    
    然后通过”shift + >”或”shift + <”可以向右或左改变排序列，下图是按一次”shift + >”


限制 cpu 占用 

> [参考](https://www.howtoing.com/how-to-limit-cpu-usage-with-cpulimit-on-ubuntu-linux/)

    apt install cpulimit
    # 测试 cpu 占用 100% 的情况
    dd if=/dev/zero of=/dev/null &
    top 
    ....
    # 快捷键 P ,即可根据cpu 占用排序
    
    # 现在利用 cpulimit 进行限制
    cpulimit -l 30 dd if=/dev/zero of=/dev/null &
    # top 查看 ,占用只有 33 %
    
    # 利用完全部 cpu
    # 查看cput 个数
    nproc
    # 我的 是 4 和 cpu
    for j in `seq 1 4`; do dd if=/dev/zero of=/dev/null & done
    # 查看占用情况
    top
    ....
    利用 cpulimit 限制
    for j in `seq 1 4`; do cpulimit -l 30  dd if=/dev/zero of=/dev/null & done
    
    


pmap
----

可以根据进程查看进程相关信息占用的内存情况，(进程号可以通过ps查看)如下所示：

    $ pmap -d 14596

ps
----
如下例所示：

    ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid'  其中rsz是是实际内存
    
    ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' | grep oracle |  sort -nrk5
    
其中rsz为实际内存，上例实现按内存排序，由大到小



