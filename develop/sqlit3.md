#### sqlit3

    # 创建数据库
    sqlit3 foo.db
    # 生成文件
    .databases
    # 退出
    .quit
    # 导出文件
    sqlite3 testDB.db .dump > testDB.sql

    # 数据库附加
    # main.db 附加一个 foo.db 数据库
    sqlite> attach database 'foo.db' as foo
    
    # 分离数据库
    detach database foo
    
创建表

    CREATE TABLE `userdetail` (
    	`uid` INT(10) NULL,
    	`intro` TEXT NULL,
    	`profile` TEXT NULL,
    	PRIMARY KEY (`uid`)
    );

列对齐命令 `.mode column`

打开表头显示 `.header on`

查看表: `.tables`

查看表结构: `.schema COMPANY`

删除表: `drop table database_name.table_name`

数据插入:
    
    insert into userdetail values(3,1,1),(2,2,2)

日期
    
    sqlite> select CURRENT_TIMESTAMP;
    CURRENT_TIMESTAMP  
    -------------------
    2018-09-13 10:54:35
    