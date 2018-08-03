> redis是一个开源（BSD许可），内存存储的数据结构服务器，可用作数据库，高速缓存和消息队列代理。生产中我们主要用来存储用户的登录信息，设备的详情数据，以及会员签到点赞的信息等等。下面来记录下生产中redis的备份与恢复。
提到redis备份，就不得不提及redis的持久化的两种方式：RDB和AOF。

RDB模式
---
rdb文件实际上是当前redis数据集的一个快照，redis默认也是用dump.rdb来进行备份。

（1）配置文件分析
---
先来看下redis配置文件中关于dump.rdb的配置

    save 900 1
    save 300 10
    save 60 10000

    # 将DB同步到磁盘，使用SAVE命令，自动同步的触发条件： save <秒> <更新数>
    # save 900 1 代表900秒内有1个key发生改变就触发save
    # save 300 10 代表300秒内有10个key发生改变就触发save
    # save 60 10000 代表300秒内有10个key发生改变就触发save
    # 各条件之间是‘或’的关系，也就是说有一个条件满足就会触发save的操作
    # 如果要禁用自动快照的功能，只需要将
    
    stop-writes-on-bgsave-error yes
    # 当后台进程执行save出错时，停止redis的写入操作。
    
    rdbcompression yes
    # 将rdb文件进行压缩
    
    rdbchecksum yes
    # 对rdb文件进行校验
    
    dbfilename dump.rdb
    # rdb文件命名
    
    dir /mnt/redis_data
    # rdb文件存储目录
    
也可以在命令行下查看：

    127.0.0.1:6379> CONFIG GET dir
    1) "dir"
    2) "/mnt/redis_data"
    
（2）备份命令执行
----
备份redis可以手动使用SAVE命令，执行SAVE命令会使用主进程执行快照操作，这意味着在SAVE的过程中，会阻塞主进程。

    SAVE
    
另一种操作是使用BGSAVE，使用BGSAVE的话redis会fork出一个子进程来执行快照操作，而不影响主进程。

    BGSAVE
    
下面开始备份操作，首先进入生产服务器，查看redis状态：

    127.0.0.1:6379> INFO
    ...
    # Keyspace
    db0:keys=285360,expires=3,avg_ttl=60319628
    db1:keys=193361,expires=2121,avg_ttl=55351639
    db5:keys=31,expires=2,avg_ttl=26979
    db10:keys=586,expires=586,avg_ttl=48543037

可以查看目前redis的存储状态。下面开始备份

    # redis-cli save
    OK

为了看下备份的时间，使用time命令：

    # time redis-cli save
    OK
    
    real    0m1.867s
    user    0m0.000s
    sys 0m0.010s
    
备份50万条数据，用时1.8秒，当然这跟数据的大小有直接关系。

（3）验证备份文件
----

首先到redis的快照目录下查看下备份的数据：

    # cd /mnt/redis_data
    # ls -l
    -rw-r--r-- 1 root root  39M Feb  1 19:43 dump.rdb
    
将备份的文件拉到测试环境进行恢复测试，redis的恢复也很简单，将dump.rdb文件放到需要恢复的的服务器的快照目录下，并命名为dump.rdb，然后启动redis服务即可。（以下操作在测试机上进行）

    127.0.0.1:6379> CONFIG GET dir
    1) "dir"
    2) "/mnt/redis_data"
    
    127.0.0.1:6379> INFO 
    ...
    # Keyspace
    127.0.0.1:6379> 
    127.0.0.1:6379> 
    127.0.0.1:6379> 
    # 没有数据
    
将备份文件拷贝到`/mnt/redis_data/`下

    # ls -lh 
    total 39M
    -rw-r--r--. 1 root root 39M Feb  1 06:54 dump.rdb
    
启动服务

    #  /usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf
    
查看redis数据状态

    127.0.0.1:6379> INFO
    ...
    # Keyspace
    db0:keys=285363,expires=3,avg_ttl=56465074
    db1:keys=193350,expires=2106,avg_ttl=58764349
    db5:keys=29,expires=0,avg_ttl=0
    db10:keys=586,expires=586,avg_ttl=44861233
    
数据恢复成功。

（4）写成脚本定时执行
----

    #!/bin/bash
    REDIS_DIR=/mnt/redis_data
    REDIS_CMD=/usr/local/redis/bin/redis-cli
    now="$(date -d'+0 day' +'%Y%m%d%H%M%S')"
    
    $REDIS_CMD save 
    [ $? -eq 0 ] && {
      cp $REDIS_DIR/dump.rdb $REDIS_DIR/dump_${now}.rdb
        rsync -avz $REDIS_DIR/dump_${now}.rdb ruser@192.168.1.122::dbm --password-file=/etc/rsync.passwd
    }
加入定时任务：

    5 0 * * *   /bin/sh  /opt/sh/redis_bkup.sh &>/dev/null