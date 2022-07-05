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

如果不使用 eval
````bash
set -- one two three
echo $1
n=1
echo ${$n} # zsh: bad substitution ❌
echo $($n)  # zsh: command not found: 1 ❌
echo \$$n # $1 ❌
eval echo \$$n # one ✅
````



