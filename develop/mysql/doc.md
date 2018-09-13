#### # 基本文档

#### # 创建表

    CREATE TABLE `t1` (
      `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
      `name` varchar(20) NOT NULL COMMENT '用户名',
      `password` varchar(20) NOT NULL COMMENT '密码',
      `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
      `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4

#### # 快速插入数据

    insert into t1 set username="admin",password='admin',created_at=CURRENT_TIMESTAMP,updated_at=CURRENT_TIMESTAMP
    insert into t1 (name,password,created_at,updated_at) values('root','root',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)
    

#### # 时间
    
    # 当前时间
    NOW()   2018-09-13 15:02:06

#### # 表结构修改
    
    # 添加字段
    alter table t1 add FIELD_NAME FIELD_TYPE ;
    # 多个字段添加
    alter table t1 add (app_id varchar(20) not null,bundleID varchar(20) not null);



    # 删除某个字段
    alter table t1 drop column FIELD_NAME;
    
    # 修改字段类型
    alter table t1 modify FIELD_NAME int(5)
    
    # 修改字段名称
    alter table t1 change old_field_name new_field_name FIELD_TYPE
    
    # 添加索引
    alter table t1 add index name_index(name)
    
    # 删除索引
    drop index name_index on t1
    
    
    
    # 主键修改
    # 删除主键
    alter table t1 change id id int
    alter table t1 drop primary key;
        
    # 添加主键
    alter table t1 add primary key (id)
    alter table t1 change id id int not null auto_increment 
    # 添加主键的同时添加自增
    alter table t1 change id id int not null auto_increment primary key
    
#### # 表复制


第一、只复制表结构到新表

    create table new_table select * from odl_table where 1=2
    或者
    create table new_table like odl_table 

第二、复制表结构及数据到新表

    create table new_table select * from odl_table 

从已有结果创建新的表

    create table 新表 select * from old_table where field1=value1 

1=1 和 1=2 的区别?

    mysql root@localhost:test> select * from t1 where 1=2
    +----+------+----------+------------+------------+
    | id | name | password | created_at | updated_at |
    +----+------+----------+------------+------------+
    0 rows in set
    Time: 0.007s
    mysql root@localhost:test> select * from t1 where 1=2
    +----+------+----------+------------+------------+
    | id | name | password | created_at | updated_at |
    +----+------+----------+------------+------------+
    0 rows in set
    Time: 0.012s

#### # 服务器元数据获取
    
    SELECT VERSION( )	服务器版本信息
    SELECT DATABASE( )	当前数据库名 (或者返回空)
    SELECT USER( )	当前用户名
    SHOW STATUS	服务器状态
    SHOW VARIABLES	服务器配置变量


#### # ip 处理
> inet_aton()和inet_ntoa()

    +------------------------+
    | inet_aton('127.0.0.1') |
    +------------------------+
    | 2130706433             |
    +------------------------+
    
    +-------------------------+
    | inet_ntoa('2130706433') |
    +-------------------------+
    | 127.0.0.1               |
    +-------------------------+
    

##### # 字符串处理[参考](https://www.cnblogs.com/geaozhang/p/6739303.html)

![image](http://oj74t8laa.bkt.clouddn.com/md/mysql/1113510-20170420154333931-7624401.png)
