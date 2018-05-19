> 总结部分 Nginx 优化 ,[其他的,点击这里](https://www.whatdy.com/articles/2018/05/nginx-optimize.html)

1.查看 web 服务器的并发请求数以及 TCP 连接状态

    netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
    或者

    netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,"t",state[key]}'


统计 IP 访问次数

    cat access.log| awk -F \" '{print $7}' | awk -F \| '{++S[$2]} END {for(a in S) print a, S[a]}'


    LAST_ACK 5 （正在等待处理的请求数）
    SYN_RECV 30 
    ESTABLISHED 1597 （正常数据传输状态） 
    FIN_WAIT1 51 
    FIN_WAIT2 504 
    TIME_WAIT 1057 （处理完毕，等待超时结束的请求数）

其他参数说明:

    CLOSED：无连接是活动的或正在进行
    LISTEN：服务器在等待进入呼叫 
    SYN_RECV：一个连接请求已经到达，等待确认 
    SYN_SENT：应用已经开始，打开一个连接 
    ESTABLISHED：正常数据传输状态 
    FIN_WAIT1：应用说它已经完成 
    FIN_WAIT2：另一边已同意释放 
    ITMED_WAIT：等待所有分组死掉 
    CLOSING：两边同时尝试关闭 
    TIME_WAIT：另一边已初始化一个释放 
    LAST_ACK：等待所有分组死掉


#  参考 

[Nginx启动SSL功能，并进行功能优化，你看这个就足够了](https://www.cnblogs.com/piscesLoveCc/p/6120875.html)

[nginx应用总结（2）--突破高并发的性能优化](https://www.cnblogs.com/kevingrace/p/6094007.html)

[Nginx高并发下的优化](https://segmentfault.com/a/1190000011405320)

[nginx日志配置](http://www.ttlsa.com/linux/the-nginx-log-configuration/)