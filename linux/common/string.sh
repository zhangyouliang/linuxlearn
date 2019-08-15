#!/usr/bin/env bash

# 参考: https://www.jianshu.com/p/b051c0ed657a
# 参考: https://www.cnblogs.com/gaochsh/p/6901809.html
##### 字符串比较
# 逻辑真 (pattern matching)  
if [[ "a.txt" == a* ]];then echo true; else echo false ; fi
# output:true
if [[ -z $a ]];then echo true; else echo false ; fi   
# output:true
if [[ -n $a ]];then echo true; else echo false ; fi
# output:false
# 逻辑真 (regex matching)  
if [[ "a.txt" =~ .*\.txt ]];then echo true; else echo false ; fi
# output:true
# 逻辑真 (string comparision), 按ascii值比较  ([[]] 不能比较数字)
if [[ "11" < "2" ]];then echo true; else echo false ; fi    
# output:true


### $@ $* 区别?
set "1" "2" "3" "4"
for i in "$@";do
    echo $i
done
# output:
# 1
# 2
# 3
# 4

for i in "$*";do
    echo $i
done
# output:
# 1 2 3 4

# "$@" 将参数分别表示, "@*" 将参数合并到一块
# @*,$@ 不影响


### 字符串匹配并且替换
str="apple, tree, apple tree,apple"
echo ${str/apple/APPLE}   # 替换第一次出现的apple  
# output: APPLE, tree, apple tree,apple
echo ${str//apple/APPLE}  # 替换所有apple  
# output: APPLE, tree, APPLE tree,APPLE
echo ${str/#apple/APPLE}  # 如果字符串str以apple开头，则用APPLE替换它  
# output:  APPLE, tree, apple tree,apple
echo ${str/%apple/APPLE}  # 如果字符串str以apple结尾，则用APPLE替换它  
# output:  apple, tree, apple tree,APPLE


### 字符串匹配显示的内容

str=abc1212abc 
echo ${str:0:4} 
# 或者
expr ${str:0:4} 
expr substr $str 1 4 
# output: abc1
expr match $str '\([a-z]*\)'
# output: abc
