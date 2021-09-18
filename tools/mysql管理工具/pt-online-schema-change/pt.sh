#!/bin/bash


table=$1
alter_conment=$2
​
cnn_host='127.0.0.1'
cnn_user='user'
cnn_pwd='password'
cnn_db='database_name'
​
echo "$table"
echo "$alter_conment"
/root/percona-toolkit-2.2.19/bin/pt-online-schema-change --charset=utf8 --no-version-check --user=${cnn_user} --password=${cnn_pwd} --host=${cnn_host}  P=3306,D=${cnn_db},t=$table --alter 
"${alter_conment}" --execute



# 添加表字段 如添加表字段SQL语句为:
# ALTER TABLE `tb_test` ADD COLUMN `column1` tinyint(4) DEFAULT NULL;

# 那么使用pt-online-schema-change则可以这样写
# sh pt.sh tb_test "ADD COLUMN column1 tinyint(4) DEFAULT NULL"