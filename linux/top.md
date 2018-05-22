> top: 查看linux进程内存占用情况

top
---

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