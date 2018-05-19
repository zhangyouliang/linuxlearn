> mkfifo: 命令创建一个FIFO特殊文件，是一个命名管道（可以用来做进程之间通信的桥梁）

mkfifo 命令
----

- 管道也是一种文件，一般是linux中的一个页大小，4k，管道数据一旦被读取就没了。

- 管道是单方向


    # create pipe
    mkfifo log.pipe
    ls -l 

    # 一个输入,多个接收
    #窗口1 
    cat < log.pipe

    #窗口2 
    cat < log.pipe

    #窗口3
    echo "lzz" > log.pipe


一个输出,多个输入

Python

    #coding:utf-8
    #logpipe.py
    import time
    import sys

    word = sys.argv[1]

    while 1:
        print >> sys.stdout, word
        time.sleep(1)


测试

    #窗口1 
    cat < log.pipe
    
    #窗口2 
    python logpipe.py win1 > log.pipe
    
    #窗口3 
    python logpipe.py win2 > log.pipe
    
    #输出
    win2
    win2
    win2
    win2
    win1
    win1