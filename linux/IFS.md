IFS
===

> Linux下有一个特殊的环境变量叫做IFS，叫做内部字段分隔符
> 默认情况下，bash shell会将下面的字符当做字段分隔符：空格、制表符、换行符。

如何查看 IFS

````bash
# -n 避免添加换行符
echo -n "$IFS" | od -A x -t c
0000000       \t  \n  \0                                    
0000004

# 或者
echo -n "$IFS" | hexdump -c


````

字符串拆分为数组
````bash
IFS="," read -r -a test <<< `echo 1,2,3,4,5,6`
# test 变量则为数组
declare -p test
````

字符串拼接
```bash
function kube::util::join {
  local IFS="$1"
  shift
  echo "$*"
}
kube::util::join , a b c d e f 
```

IFS 的修复与维护
===
因为IFS是系统级变量，修改使用后记得要恢复原样，否则后续程序就会出现一些奇奇怪怪的异常，别怪我没告诉你啊，我自己曾经因为这个问题踩了个大坑。

第1种方式：保存到临时变量当中,用完之后恢复

````bash
touch "a b c.txt"  
IFS_SAVE=$IFS
IFS=         
for item in `ls`;do
    echo "file: $item"
done

file: a b c.txt
a.json
file

IFS=$IFS_SAVE
# 查看恢复后的 IFS 变量
echo -n "$IFS" | hexdump -c
````

第2种方式：使用local来声明要使用的IFS变量来覆盖全局变量，由于local变量只在局部有效，所以操作完不需要恢复IFS


````bash
function show_filename {
    local IFS=$'\n'
    echo -n "$IFS" | hexdump
    for item in `ls`;do
        echo "file: $item"
    done
}
# 先打印默认的IFS
echo -n "$IFS" | hexdump

# 函数内会更改IFS并进行操作，但函数内并不会进行恢复
show_filename

# 退出函数后再打印IFS看看
echo -n "$IFS" | hexdump

````

特殊参数`$*`受`IFS`影响, 可以类比一下 "$@" 和 "$*" 带有引号时的输出区别

````bash
set 1 2 3 4 5 5
echo \$*=$*  # output: $*=1 2 3 4 5 5
echo \$*="$*" # output: $*=1-2-3-4-5-5

var=(1 2 3 4 5)
echo \${var[*]}=${var[*]} # ${var[*]}=1 2 3 4 5
echo "\"\${var[*]}\"=${var[*]}" # "${var[*]}"=1-2-3-4-5
````


建议使用 `IFS=$'string'` 的形式设置IFS

上面的各个例子中都是使用`IFS=$'string'`(例如：`IFS=$' \t\n'`)的奇怪的方式来设置 IFS，既然`'\n'`是常量，为什么前面还要使用`$`符号呢？

这里跟`$'string'`的特殊引用方式有关，详细解释参考`Bash手册的第3.1.2.4节“ANSI-C Quoting”`，这一节提到`$'string'`的引用方式会被当做特别对待，使用这种方式的值会使用反斜杠转义的字符。
对于`IFS=$' \t\n'`就包含了对`“\t”和“\n”`两个转义。

````bash
# 使用"string"的方式，无法使反斜杠转义后续字符
IFS=" \t\n"
echo -n "$IFS" | hexdump -c
# output:
# 0000000       \   t   \   n                                            
# 0000005

# 使用'string'的方式，无法使反斜杠转义后续字符
IFS=$" \t\n"
echo -n "$IFS" | hexdump -c
# output:
# 0000000       \   t   \   n                                            
# 0000005


# 使用$'string'的方式，成功使用反斜杠转义
IFS=$' \t\n'
echo -n "$IFS" | hexdump -c
# output:
# 0000000      \t  \n                                                    
# 0000003

# 批量替换 .mp4 后缀改为 .ts
IFS=$'\n'
for var in `ls *.mp4`;do
mv "$var" ${var/.mp4/.ts}
done
````