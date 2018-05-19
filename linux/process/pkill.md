> pkill 命令可以按照进程名杀死进程。pkill 和 killall 应用方法差不多，也是直接杀死运行中的程序；如果您想杀掉单个进程，请用kill来杀掉。


语法
---

    pkill(选项)(参数)
    
选项
----

    -o：仅向找到的最小（起始）进程号发送信号；
    -n：仅向找到的最大（结束）进程号发送信号；
    -P：指定父进程号发送信号；
    -g：指定进程组；
    -t：指定开启进程的终端。
    


实例
---

    $ pgrep -l nginx
    2979 nginx
    2978 nginx
    $ pkill nginx

也就是说：`kill`对应的是`PID`，`pkill`对应的是command。