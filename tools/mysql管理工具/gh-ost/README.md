gh-ost
====

- [gh-ost 下载](https://github.com/github/gh-ost/releases)


主库模式

````
gh-ost \
--max-load=Threads_running=20 \
--critical-load=Threads_running=50 \
--critical-load-interval-millis=5000 \
--chunk-size=1000 \
--user="root" \
--password="qcloud@2018" \
--host='127.0.0.1' \
--port=3306 \
--database="wjq" \
--table="employees" \
--verbose \
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
--execute 2>&1 | tee /tmp/rebuild_employees.log

````

从库模式

````
gh-ost \
   --max-load=Threads_running=16 \
   --critical-load=Threads_running=32 \
   --chunk-size=1000  \
   --initially-drop-old-table \
   --initially-drop-ghost-table \
   --initially-drop-socket-file \
   --ok-to-drop-table \
   --host="10.249.5.39" \
   --port=3307 \
   --user="dbadmin" \
   --password="12345" \
   --assume-rbr \
   --allow-on-master \
   --assume-master-host=10.249.5.39:3306 \
   --database="gh_ost" \
   --table="gh_01" \
   --alter="add column c4 varchar(50) not null default ''" \
   --panic-flag-file=/tmp/ghost.panic.flag \
   --serve-socket-file=/tmp/ghost.sock \
   --verbose \
   --execute
````

测试模式

````
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
   --password="12345" \
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
- [Online DDL 工具 gh-ost实战（一）](http://www.seiang.com/?p=770)
