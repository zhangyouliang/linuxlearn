> ltrace命令是用来跟踪进程调用库函数的情况。

语法
--
    ltrace [option ...] [command [arg ...]]
选项
--
    -a 对齐具体某个列的返回值。
    -c 计算时间和调用，并在程序退出时打印摘要。
    -C 解码低级别名称（内核级）为用户级名称。
    -d 打印调试信息。
    -e 改变跟踪的事件。
    -f 跟踪子进程。
    -h 打印帮助信息。
    -i 打印指令指针，当库调用时。
    -l 只打印某个库中的调用。
    -L 不打印库调用。
    -n, --indent=NR 对每个调用级别嵌套以NR个空格进行缩进输出。
    -o, --output=file 把输出定向到文件。
    -p PID 附着在值为PID的进程号上进行ltrace。
    -r 打印相对时间戳。
    -s STRLEN 设置打印的字符串最大长度。
    -S 显示系统调用。
    -t, -tt, -ttt 打印绝对时间戳。
    -T 输出每个调用过程的时间开销。
    -u USERNAME 使用某个用户id或组ID来运行命令。
    -V, --version 打印版本信息，然后退出。
    -x NAME treat the global NAME like a library subroutine.（求翻译）
    

实例
---

    # 输出调用时间开销
    ltrace -T nginx
    
    # 显示系统调用
    ltrace -S nginx
    
    # 显示 pid 的调用信息
    ltrace -p <pid>
    