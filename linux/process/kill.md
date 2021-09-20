kill
====


kill 的常用信号
===
> 只有第9种信号(SIGKILL)才可以无条件终止进程，其他信号进程都有权利忽略。

````
# 查看全部信号
kill -l 


HUP     1    终端断线
INT       2    中断（同 Ctrl + C）
QUIT    3    退出（同 Ctrl + \）
TERM    15    终止
KILL      9    强制终止
CONT   18    继续（与STOP相反， fg/bg命令）
STOP    19    暂停（同 Ctrl + Z）
````

- SIGINT 和 SIGTERM：ctrl+C 触发的是 SIGINT，别的没区别
- SIGINT SIGTERM 可以被捕获、处理，所以不一定会使程序退出
- SIGKILL 不能被捕获，一定会使程序退出

例子:

````
格式：kill -l <signame>
显示指定信号的数值。

格式：kill -9 <pid>
格式：kill -KILL <pid>
强制杀掉指定进程，无条件终止指定进程。

格式：kill %<jobid>
格式：kill -9 %<jobid>
杀掉指定的任务（使用jobs命令可以列出）

格式：kill -QUIT <pid>
格式：kill -3 <pid>
使得程序正常的退出。



killall命令
killall命令杀死同一进程组内的所有进程。其允许指定要终止的进程的名称，而非PID。
# killall httpd 
````