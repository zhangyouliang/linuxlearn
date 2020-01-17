#!/usr/bin/env bash

# 注: 该文件仅仅是  ./README.md 的一些测试,没有其他用途

echo "####### 特殊变量 #######"
echo "\$0:" $0
echo "\$1:" $1
echo "\$#:" $#
echo "\$@:" $@
echo "\$*:" $*
# ./demo.sh "a" "b" "c" 
#  $* 将参数看做一个整体
for i in "$*";do
    echo $i
done

echo "\$$" $$
echo "\$?" $?

cd /usr/local && ls -l | wc -l 
# $_ 为上一个命令的路径
echo "\$_" $_


echo "####### 变量替换 #######"

str="abcdefhigklmnopqrstuvwxyz"

echo ${str}
# 如果 $str1 变量不存在就是用 $str 变量
echo ${str1-$str}
# 如果 $str1 变量为空或者被删除,就是用 $str 变量
echo ${str1:-$str}


str2="def1"
str3="def2"
echo ${!st*} # str str2 str3

echo "####### 字符串截取 #######"

str="dir1/dir2/dir3/my.file.txt"
# 删除第一次出现的左边(从前)
echo ${str#*/}
# 删除最后一次出现的左边(从前)
echo ${str##*/}
# 删除第一次出现的右边数据(从后)
echo ${str%/*}
echo ${str%%/*}



