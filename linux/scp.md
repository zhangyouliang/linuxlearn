> scp 远程cp 命令

####  例子

    # 通过<跳板机器> 代理<目标机器>,将 hello.py 文件传输到<目标机器> 上
    scp -o ProxyCommand='ssh -q root@<跳板机器> -W %h:%p' hello.py root@<目标机器>:~/