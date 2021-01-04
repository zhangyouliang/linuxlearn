>  查看进程的内存映像信息

语法
---
    pmap pid
    pmap pid1 pid2 pid3 ....
选项
----

    -x extended显示扩展格式
    -d device显示设备格式
    -q quiet不显示header/footer行
    -V 显示版本信息
   
实例
----

````
# 查看进程用了多少内存
# pmap PID
pmap $(pgrep php-fpm) | less
````