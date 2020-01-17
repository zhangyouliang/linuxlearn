> expr 命令是一款表达式计算工具,使用它完成表达式的求值操作

常用表达式:
* 加法运算：+
* 减法运算：-
* 乘法运算：\*
* 除法运算：/
* 求摸（取余）运算：%

语法: 

    expr (选项) (参数)

选项:

````
ARG1 | ARG2
ARG1 & ARG2
ARG1 < ARG2
ARG1 <= ARG2
ARG1 = ARG2
ARG1 != ARG2
ARG1 >= ARG2
ARG1 > ARG2
ARG1 - ARG2
ARG1 * ARG2
ARG1 / ARG2

常用的几个参数:

match STRING REGEXP
substr STRING POS LENGTH
index STRING CHARS
length STRING
````

实例:
````
str=abc1212abc 
# 字符串截取
expr substr $str 1 4 
# 字符串比较
expr match $str '\([a-z]*\)'
# 字符串出现的索引(从1开始)
expr index $str a
# 字符串长度
expr length $str



````