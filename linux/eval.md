> eval: 

命令参数
---


案例
---

````bash
# 简单使用
pipe="|"
eval ls $pipe wc -l

# 变量替换
set -- one two three
echo $1 # one
n=1
eval echo \${$n} # one


````



