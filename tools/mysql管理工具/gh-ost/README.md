gh-ost
====

- [gh-ost 下载](https://github.com/github/gh-ost/releases)


主库模式

````s
gh-ost \
--max-load=Threads_running=20 \
--critical-load=Threads_running=50 \
--critical-load-interval-millis=5000 \
--chunk-size=1000 \
--user="root" \
--password="123456" \
--host='127.0.0.1' \
--port=3306 \
--database="dbadmin" \
--table="employees" \
--alter="engine=innodb" \
--assume-rbr \
--cut-over=default \
--cut-over-lock-timeout-seconds=1 \
--dml-batch-size=10 \
--allow-on-master \
--concurrent-rowcount \
--default-retries=10 \
--heartbeat-interval-millis=2000 \
--panic-flag-file=/tmp/ghost.panic.flag \
--postpone-cut-over-flag-file=/tmp/ghost.postpone.flag \
--timestamp-old-table \
--verbose \
--execute 2>&1 | tee /tmp/rebuild_employees.log

````

从库模式


````s
gh-ost \
--host="10.249.5.39" \
--port=3306 \
--user="dbadmin" \
--password="123456" \
--database="gh_ost" \
--table="gh_01" \
--alter="add column c4 varchar(50) not null default ''" \
--assume-rbr \
--allow-on-master \
--assume-master-host=10.249.5.39:3306 \
--max-load=Threads_running=16,Threads_connected=160 \
--critical-load=Threads_running=32,Threads_connected=320 \
--critical-load-interval-millis=5000 \
--chunk-size=5000 \
--concurrent-rowcount \
--cut-over=atomic \
--cut-over-lock-timeout-seconds=3 \
--initially-drop-ghost-table=true \
--initially-drop-old-table=true \
--initially-drop-socket-file=true \
--ok-to-drop-table \
--timestamp-old-table=true \
--panic-flag-file=/tmp/ghost.panic.flag \
--serve-socket-file=/tmp/ghost.sock \
--verbose \
--execute
````

- --aliyun-rds=true 如果是阿里云需要添加
- -critical-load string   一系列逗号分隔的status-name=values组成，当MySQL中status超过对应的values，gh-ost将会退出。【用的较少】
- -max-load string       一系列逗号分隔的status-name=values组成，当MySQL中status超过对应的values，gh-ost将采取节流(throttle)措施。


````sql
show status like '%Threads%'
-- - Threads_connected：当前线程连接个数
-- - Threads_running： 当前进程运行个数
-- - Threads_cached：已经被线程缓存池缓存的线程个数
-- - Threads_created：表示创建过的线程数，如果发现Threads_created值过大的话，表明MySQL服务

````

测试模式

````s
gh-ost \
--test-on-replica \
--max-load=Threads_running=16 \
--critical-load=Threads_running=32 \
--chunk-size=1000  \
--initially-drop-old-table \
--initially-drop-ghost-table \
--initially-drop-socket-file \
--host="10.249.5.39" \
--port=3307 \
--user="dbadmin" \
--password="123456" \
--assume-rbr \
--database="gh_ost" \
--table="gh_01" \
--alter="add column c4 varchar(50) not null default ''" \
--panic-flag-file=/tmp/ghost.panic.flag \
--serve-socket-file=/tmp/ghost.sock \
--verbose \
--execute
````

#### # 参考
- [阿里云RDS在线DDL工具gh-ost](https://www.cnblogs.com/DBABlog/p/12926952.html)
- [gh-ost 比较安全的Online DDL](https://blog.csdn.net/zhoutaotao123/article/details/93232866)
- [MySQL大表DDL方式对比](https://blog.csdn.net/weixin_37692493/article/details/118328563)
- [Online DDL 工具 gh-ost实战（一）, 参数介绍](http://www.seiang.com/?p=770)
- [gh-ost 参数介绍](https://blog.51cto.com/lee90/2062609)
