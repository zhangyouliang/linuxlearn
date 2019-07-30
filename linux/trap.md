> trap: Bash 的内部命令 trap，让我们可以在 Shell 脚本内捕获特定的信号并对它们进行处理。


trap 命令的语法如下所示：

    trap command signal [ signal ... ]

当 Shell 收到信号 signal(s) 时，command 将被读取和执行。

* 如果 signal 是 0 或 EXIT 时，command 会在 Shell 退出时被执行。
* 如果 signal 是 DEBUG 时，command 会在每个命令后被执行。
* signal 也可以被指定为 ERR，那么每当一个命令以非 0 状态退出时，command 就会被执行
* 当非 0 退出状态来自一个 if 语句部分，或来自 while、until 循环时，command 不会被执行）。

trap 使用场景:

- 处理相关信号量
- 调试相关信息: 退出（EXIT）、调试（DEBUG）、错误（ERR）、返回（RETURN）等情况

命令参数
---


案例
---

捕获退出码0

    # 捕获退出状态 0
    trap 'echo "Exit 0 signal detected..."' 0
    # 打印信息
    echo "This script is used for testing trap command."

    # 以状态（信号）0 退出此 Shell 脚本
    exit 0
    ### 输出
    This script is used for testing trap command.
    Exit 0 signal detected...

    
捕获信号 SIGINT，然后打印相应的信息

    trap "echo 'You hit Ctrl + C! I am ignoring you.'" SIGINT

    # 捕获信号 SIGTERM，然后打印相应信息
    trap "echo 'You tried to kill me! I am ignoring you.'" SIGTERM

    # 循环 5 次
    for i in {1..5}; do
        echo "Iteration $i of 5"
        sleep 5
    done

脚本退出时,执行清理操作

    trap 'my_exit; exit' SIGINT SIGQUIT
    # 用户调用 kill -1 PID 命令
    trap 'echo Going down on a SIGHUP - signal 1, no exiting...; exit' SIGHUP
    count=0
    tmp_file=`mktemp /tmp/file.$$.XXXXXX`
    my_exit()
    {
            echo "You hit Ctrl-C/Ctrl-\, now exiting..."
            rm -f $tmp_file >& /dev/null
    }
    echo "Do something..." > $tmp_file
    # 执行无限循环
    while :
    do
        sleep 1
        count=$(expr $count + 1)
        echo $count
    done




参考
---

* [进程（七）：trap 语句](https://www.jianshu.com/p/8f21f12cf756)

