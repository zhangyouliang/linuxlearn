mysql 管理工具
=====

### # 工具列表

- mycli mysql 提示命令行
- mytop mysql 性能查看工具
- gh-ost mysql ddl 修改工具 [下载](https://github.com/github/gh-ost/releases)
- pt-online-schema-change mysql ddl 修改工具 [下载](percona.com/get/percona-toolkit.tar.gz)

### # 常用命令

````
mysql -h192.168.1.00 -umysql -pxxx -e "show processlist" | grep 'Waiting for table metadata lock'|grep select | awk '{print $1}' | xargs -i% mysql -h192.168.1.100 -umysql -pxxx -e "kill %"

查看事务等待情况：

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


查看当前进行中的事务：

5.5版本（我们生产环境版本）：

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

附：5.6版本（5.6原生支持在线DDL，感兴趣的可以研究下）

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


### # 参考

- [gh-ost：在线DDL修改MySQL表结构工具](https://zhang.ge/5133.html)
- [MySQL在线DDL修改表结构的简单经验分享](https://zhang.ge/5134.html)