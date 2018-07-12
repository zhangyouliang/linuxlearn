> mysql 锁表

查看表所情况

    jfq-spider> show status like 'table%'
    +----------------------------+-----------+
    | Variable_name              | Value     |
    +----------------------------+-----------+
    | Table_locks_immediate      | 230201115 |
    | Table_locks_waited         | 40        |
    | Table_open_cache_hits      | 0         |
    | Table_open_cache_misses    | 0         |
    | Table_open_cache_overflows | 0         |
    +----------------------------+-----------+

`table_lock_wait` 出现表级锁定争用而发生等待的次数，`table_lock_immediate`产生表级锁定的次数；




    jfq-spider> show status like 'innodb_row_lock%'
    +-------------------------------+--------+
    | Variable_name                 | Value  |
    +-------------------------------+--------+
    | Innodb_row_lock_current_waits | 0      |
    | Innodb_row_lock_time          | 394650 |
    | Innodb_row_lock_time_avg      | 974    |
    | Innodb_row_lock_time_max      | 14415  |
    | Innodb_row_lock_waits         | 405    |
    +-------------------------------+--------+

`Innodb_row_lock_current_waits`：当前正在等待锁定的数量；

`Innodb_row_lock_time` ：从系统启动到现在锁定的总时间长度，单位ms；

`Innodb_row_lock_time_avg` ：每次等待所花平均时间；

`Innodb_row_lock_time_max`：从系统启动到现在等待最长的一次所花的时间；

`Innodb_row_lock_waits` ：从系统启动到现在总共等待的次数。


mysql 解锁
----
第一种

    show processlist

查到所进程  `kill id`


mysql 锁表
----
    
    mysql>UNLOCK TABLES;
    
    锁表
    
    锁定数据表，避免在备份过程中，表被更新
    
    mysql>LOCK TABLES tbl_name READ;
    
    为表增加一个写锁定：
    
    mysql>LOCK TABLES tbl_name WRITE;



