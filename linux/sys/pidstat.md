> pidstat 

    # 上下文切换查看
    sar -w 1 

    # pidstat -w   每个进程的context switching情况
    # pidstat -wt  细分到每个threads
    查看proc下的文件方法如下：
    # pid=307
    # grep ctxt /proc/$pid/status
    voluntary_ctxt_switches:        41    #自愿的上下文切换
    nonvoluntary_ctxt_switches:     16    #非自愿的上下文切换
