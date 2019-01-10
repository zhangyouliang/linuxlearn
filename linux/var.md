### linux 相关变量

    $0 获取当前执行脚本的文件名包括路径
    $# 执行命令行(脚本)参数的总个数
    $@   这个执行程序的所有参数
    $* 获取当前shell 的所有参数(注意与$@区别)
    $! 上一个执行命令的PID
    $$ 获取当前shell的PID
    $_ 在此之前执行的命令或者脚本的最后一个参数
    $? 上一个命令的退出状态
    $n 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。

## $* 和 $@ 的区别

    $* 和 $@ 都表示传递给函数或脚本的所有参数，不被双引号" "包含时，都以"$1" "$2" … "$n" 的形式输出所有参数。

    echo "print each param from\"\$*\""
    for i in "$*"
    do
        echo "$i"
    done

    echo "print each param from\"\$@\""
    for i in "$@"
    do
        echo "$i"
    done

    ## 输出
    print each param from"$*"
    6
    stop a b c de f
    print each param from"$@"
    stop
    a
    b
    c
    de
    f

