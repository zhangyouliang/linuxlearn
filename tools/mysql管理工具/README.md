mysql 管理工具
=====

### # 工具列表

- mycli mysql 提示命令行
- mytop mysql 性能查看工具
- gh-ost mysql ddl 修改工具 [下载](https://github.com/github/gh-ost/releases)
- pt-online-schema-change mysql ddl 修改工具 [下载](percona.com/get/percona-toolkit.tar.gz)

### # 常用命令

查看并且杀死查询锁死的sql

````bash
mysql -h192.168.1.00 -umysql -pxxx -e "show processlist" | grep 'Waiting for table metadata lock'|grep select | awk '{print $1}' | xargs -i% mysql -h192.168.1.100 -umysql -pxxx -e "kill %"
````

````sql

-- 查看事务等待情况：

SELECT
     r.trx_id waiting_trx_id,
     r.trx_mysql_thread_id waiting_thread,
     r.trx_query waiting_query,
     b.trx_id blocking_trx_id,
     b.trx_mysql_thread_id blocking_thread,
     b.trx_query blocking_query
FROM
     information_schema.innodb_lock_waits w
INNER JOIN information_schema.innodb_trx b ON b.trx_id = w.blocking_trx_id
INNER JOIN information_schema.innodb_trx r ON r.trx_id = w.requesting_trx_id;


-- 查看当前进行中的事务：

-- 5.5版本（我们生产环境版本）：

SELECT
     a.trx_id,
     a.trx_state,
     a.trx_started,
     a.trx_query,
     b.ID,
     b. USER,
     b. HOST,
     b.DB,
     b.COMMAND,
     b.TIME,
     b.STATE,
     b.INFO
FROM
     information_schema.INNODB_TRX a
LEFT JOIN information_schema.PROCESSLIST b ON a.trx_mysql_thread_id = b.id
WHERE
     b.COMMAND = 'Sleep';

-- 附：5.6版本（5.6原生支持在线DDL，感兴趣的可以研究下）

SELECT
     a.trx_id,
     a.trx_state,
     a.trx_started,
     a.trx_query,
     b.ID,
     b.USER,
     b.DB,
     b.COMMAND,
     b.TIME,
     b.STATE,
     b.INFO,
     c.PROCESSLIST_USER,
     c.PROCESSLIST_HOST,
     c.PROCESSLIST_DB,
     d.SQL_TEXT
FROM
     information_schema.INNODB_TRX a
LEFT JOIN information_schema.PROCESSLIST b ON a.trx_mysql_thread_id = b.id
AND b.COMMAND = 'Sleep'
LEFT JOIN PERFORMANCE_SCHEMA.threads c ON b.id = c.PROCESSLIST_ID
LEFT JOIN PERFORMANCE_SCHEMA.events_statements_current d ON d.THREAD_ID = c.THREAD_ID;


````


在5.5中，information_schema 库中增加了三个关于锁的表（innoDB引擎）：

- innodb_trx         ## 当前运行的所有事务
- innodb_locks       ## 当前出现的锁
- innodb_lock_waits  ## 锁等待的对应关系

````
desc information_schema.innodb_locks;
+————-+———————+——+—–+———+——-+
| Field       | Type                | Null | Key | Default | Extra |
+————-+———————+——+—–+———+——-+
| lock_id     | varchar(81)         | NO   |     |         |       |#锁ID
| lock_trx_id | varchar(18)         | NO   |     |         |       |#拥有锁的事务ID
| lock_mode   | varchar(32)         | NO   |     |         |       |#锁模式
| lock_type   | varchar(32)         | NO   |     |         |       |#锁类型
| lock_table  | varchar(1024)       | NO   |     |         |       |#被锁的表
| lock_index  | varchar(1024)       | YES  |     | NULL    |       |#被锁的索引
| lock_space  | bigint(21) unsigned | YES  |     | NULL    |       |#被锁的表空间号
| lock_page   | bigint(21) unsigned | YES  |     | NULL    |       |#被锁的页号
| lock_rec    | bigint(21) unsigned | YES  |     | NULL    |       |#被锁的记录号
| lock_data   | varchar(8192)       | YES  |     | NULL    |       |#被锁的数据
+————-+———————+——+—–+———+——-+

desc information_schema.innodb_lock_waits;

+——————-+————-+——+—–+———+——-+
| Field             | Type        | Null | Key | Default | Extra |
+——————-+————-+——+—–+———+——-+
| requesting_trx_id | varchar(18) | NO   |     |         |       |#请求锁的事务ID
| requested_lock_id | varchar(81) | NO   |     |         |       |#请求锁的锁ID
| blocking_trx_id   | varchar(18) | NO   |     |         |       |#当前拥有锁的事务ID
| blocking_lock_id  | varchar(81) | NO   |     |         |       |#当前拥有锁的锁ID
+——————-+————-+——+—–+———+——-+

desc information_schema.innodb_trx ;
+—————————-+———————+——+—–+———————+——-+
| Field                      | Type                | Null | Key | Default             | Extra |
+—————————-+———————+——+—–+———————+——-+
| trx_id                     | varchar(18)         | NO   |     |                     |       |#事务ID
| trx_state                  | varchar(13)         | NO   |     |                     |       |#事务状态：
| trx_started                | datetime            | NO   |     | 0000-00-00 00:00:00 |       |#事务开始时间；
| trx_requested_lock_id      | varchar(81)         | YES  |     | NULL                |       |#innodb_locks.lock_id
| trx_wait_started           | datetime            | YES  |     | NULL                |       |#事务开始等待的时间
| trx_weight                 | bigint(21) unsigned | NO   |     | 0                   |       |#
| trx_mysql_thread_id        | bigint(21) unsigned | NO   |     | 0                   |       |#事务线程ID
| trx_query                  | varchar(1024)       | YES  |     | NULL                |       |#具体SQL语句
| trx_operation_state        | varchar(64)         | YES  |     | NULL                |       |#事务当前操作状态
| trx_tables_in_use          | bigint(21) unsigned | NO   |     | 0                   |       |#事务中有多少个表被使用
| trx_tables_locked          | bigint(21) unsigned | NO   |     | 0                   |       |#事务拥有多少个锁
| trx_lock_structs           | bigint(21) unsigned | NO   |     | 0                   |       |#
| trx_lock_memory_bytes      | bigint(21) unsigned | NO   |     | 0                   |       |#事务锁住的内存大小（B）
| trx_rows_locked            | bigint(21) unsigned | NO   |     | 0                   |       |#事务锁住的行数
| trx_rows_modified          | bigint(21) unsigned | NO   |     | 0                   |       |#事务更改的行数
| trx_concurrency_tickets    | bigint(21) unsigned | NO   |     | 0                   |       |#事务并发票数
| trx_isolation_level        | varchar(16)         | NO   |     |                     |       |#事务隔离级别
| trx_unique_checks          | int(1)              | NO   |     | 0                   |       |#是否唯一性检查
| trx_foreign_key_checks     | int(1)              | NO   |     | 0                   |       |#是否外键检查
| trx_last_foreign_key_error | varchar(256)        | YES  |     | NULL                |       |#最后的外键错误
| trx_adaptive_hash_latched  | int(1)              | NO   |     | 0                   |       |#
| trx_adaptive_hash_timeout  | bigint(21) unsigned | NO   |     | 0                   |       |#
+—————————-+———————+——+—–+———————+——-+
````

````sql
-- 查看进程
show processlist

-- 锁住某个表
LOCK TABLES account_data.account READ;
SELECT SLEEP(160);
UNLOCK TABLES account_data.account;

-- 查看被锁的表
show OPEN TABLES where In_use > 0;

-- 查看正在锁的事务
SELECT * FROM information_schema.innodb_locks; 

-- 查看等待锁的事务
SELECT * FROM information_schema.innodb_lock_waits; 

-- 查看 innodb 引擎
show engine innodb status

-- 查看表锁的情况
show status like 'table%';

-- 查看InnoDB_row_lock状态变量来分析系统上的行锁的争夺情况
show status like 'InnoDB_row_lock%';
````

### # 参考

- [gh-ost：在线DDL修改MySQL表结构工具](https://zhang.ge/5133.html)
- [MySQL在线DDL修改表结构的简单经验分享](https://zhang.ge/5134.html)