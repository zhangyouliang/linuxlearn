> mytop : mysql 性能监控工具

> [参考](https://blog.csdn.net/u011871037/article/details/52608831)

Top 命令可以查看操作系统的性能状态,mytop 命令类似 top 命令，界面结构也类似，只是 mytop 显示的是 mysql 的状态信息，例如我们非常关心的

QPS,慢SQL等等


    MySQL on rm-bpxxxxx073sio.mysql.rds.aliyuncs.com (5.6.16)       load  up 14+23:15:09 [14:42:39] ①
     Queries: 465.4M   qps:  377 Slow:    5.1k         Se/In/Up/De(%):    55/01/01/00  ②
     Sorts:    10 qps now:  524 Slow qps: 0.0  Threads:   15 (   4/  91) 55/01/02/00  ③
     Key Efficiency: 100.0%  Bps in/out: 68.6k/416.8k   Now in/out: 98.3k/596.0k   ④
     Replication IO:Yes SQL:Yes Delay: 0 sec.             
    
           Id      User         Host/IP         DB       Time    Cmd    State Query   ⑤                               
           --      ----         -------         --       ----    ---    ----- ----------                              
     17755725      hbdt       10.0.0.49 jfq-spider        739  Sleep                                                 
     17618726      hbdt       10.0.0.51 jfq-spider        389  Sleep                                                 
     34163068      hbdt       10.0.0.49 jfq-spider        156  Sleep                                                 
     50754384      hbdt       10.0.0.50      gblhb         36  Sleep                                                 
     50797769      hbdt       10.0.0.46      novel          3  Sleep                                                 
     34547199      hbdt       10.0.0.49      novel          2  Sleep                                                 
     34504570      hbdt       10.0.0.51 jfq-spider          1  Sleep                                                 
     17520204      hbdt       10.0.0.49      novel          0  Sleep                                                 
     17703228      hbdt       10.0.0.50      novel          0  Sleep                                                 
     17774047      hbdt   <当前执行mytop命令的客户端IP>                     0  Query     init show full processlist                  
     17811693      hbdt       10.0.0.50      novel          0  Sleep                                                 
     33835262      hbdt       10.0.0.49      novel          0  Sleep
     
 
  ① 版本信息
  
  ② 整体信息:
  
  Queries: 服务器处理过的 query 总数
  
  qps 每秒钟处理的 query 数量的平均值
  
  show 慢查询总数
  
  se/ln/up/De(%)  Select,Insert,Update,Delete 各自的占比
  
  ③ 是实时信息，本刷新周期内的信息统计，刷新周期是在配置文件中指定
  `Sorts:    33 qps now:  457 Slow qps: 0.0  Threads:   14 (   4/  92) 56/01/01/00`
  
  qps now 本周期内的每秒处理query的数量
  
  Slow qps 本周期内的每秒慢查询数量
  
  Threads 当前连接线程数量，后面括号内的第一个数字是active状态的线程数量，第二个数字是在线程缓存中的数量
   
  ④ 本周期内的 Select,Insert,Update,Delete 各自的占比 
  `Key Efficiency: 100.0%  Bps in/out: 68.6k/416.8k   Now in/out: 98.3k/596.0k   ④`
  
  Key Efficiency 表示有多少key是从缓存中读取，而不是从磁盘读取的
  
  Bps in/out 表示mysql平均的流入流出数据量
  
  Now in/out  是本周期内的流入流出数据量
  
  ⑤ 线程信息列表
  
  ```
  # 分别表示
  Id      User         Host/IP         DB       Time    Cmd    State Query   ⑤
  线程ID、用户名、      客户端的地址、  连接的数据库名称、 时间, 进程状态,  详细查询语句
  ```    
  会发现 `show full processlist` 一直都在，因为 mytop 会使用这个语句收集 mysql 信息
  
-----
辅助命令

```
? 显示帮助信息。
c 命令的总结视图(基于Com_*的统计)。
C 关闭/开启颜色模式。
d 仅仅显示指定的数据库。
e 将指定的thread_id对应的query在数据库上的explain结果展示出来。
E 展示当前复制的error信息。
f 显示指定query的完整信息。
h 显示指定的host的连接信息。
H 只显示mytop的头信息。
I show innodb status的信息。(大写i)
k kill指定的thread id。
p 显示暂停。
l 高亮慢查询。(小写L)
m 只展示qps的信息。
M 显示状态信息。
o 反序排序。
s 显示信息的refresh间隔。
u 显示指定用户的连接信息。
V show variables的相关信息。(大写v)
```  
  