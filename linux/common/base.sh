#!/usr/bin/env bash

# test
# 数字测试: -eq, -ne, -gt, -ge, -lt, -le
# 字符串测试: =, != , -z 字符串, -n 字符串
# 文件测试: -e,-r,-w,-x,-s,-d,-f,-c,-b

num1=100
num2=200
if test ${num1} -eq ${num2}
then
    echo '两个数相等！'
else
    echo '两个数不相等！'
fi


# [] 
# 等价于 test
# 算数运算
a=5
b=6
result=$[a + b] # 注意等号两边不能有空格 
# result=`expr $a + $b ` 等同于
echo "result 为： $result"









