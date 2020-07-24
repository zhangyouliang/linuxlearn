> xargs命令是给其他命令传递参数的一个过滤器，也是组合多个命令的一个工具。它擅长将标准输入数据转换成命令行参数，xargs能够处理管道或者stdin并将其转换成特定命令的命令参数。xargs也可以将单行或多行文本输入转换为其他格式，例如多行变单行，单行变多行。`xargs的默认命令是echo，空格是默认定界符`。`这意味着通过管道传递给xargs的输入将会包含换行和空白，不过通过xargs的处理，换行和空白将被空格取代`。xargs是构建单行命令的重要组件之一。
[参考](https://blog.gtwang.org/linux/xargs-command-examples-in-linux-unix/)


参数
---

- n <number> 后面接次数，每次command命令执行时，要使用几个参数。
  -  echo a b c d e f | xargs -n 2
- d 使用自己的定义的定界符来分隔参数。
- 0 如果输入的stdin含有特殊字符，例如`, \, 空格键等字符时，这个参数可以将它还原成一般字符。这个参数可以用于特殊状态。
- I 大写I,将 xargs 的每箱名称,一般是一行一行赋值给 {},可以{}代替。使用-i的时候，命令以循环的方式执行。如果有3个参数，那么命令就会连同{}一起被执行3次。在每一次执行中{}都会被替换为相应的参数。
  - echo 111:a:b:c | xargs -0 -d: -I {} echo {}
  - echo 111:a:b:c | xargs -0 -d: -I var echo var
- p 在执行每个命令的参数时，都会询问用户。
- e 这个是EOF（end of file）的意思。后面可以接一个字符串，当xargs分析到这个字符串时，就会停止工作。
  - echo a bc d e rf f | xargs -ee (输出:a bc d)
- t 显示执行的命令
- r 避免空格执行
- --max-procs 
    - 默认只用一个进程执行命令。如果命令要执行多次，必须等上一次执行完，才能执行下一次。
    - 参数指定同时用多少个进程并行执行命令。
    - --max-procs 2表示同时最多使用两个进程，--max-procs 0表示不限制进程数


> xargs 将换行,空白替换为空格

这里提供xargs这个Linux指令的使用教学，并搜集一些常用的范例程式以供参考。

在UNIX/Linux系统中，xargs这个指令跟其他的指令结合之后，将会变得非常有用，这里我们整理了一些常见的xargs使用范例与教学，透过这些简单的范例可以很快的了解xargs的各种使用方式。

 
虽然这里的范例都很简单，但是当你了解xargs的用法之后，你会发现xargs其实可以拿来处理各式各样的问题，而且非常好用，尤其是对于伺服器的系统管理者而言，在管理大量的档案与目录结构时，有这样的工具会方便很多。

xargs 基本用法
---
> xargs这个指令会标准输入（standard input）读取资料，并以空白字元或换行作为分隔，将输入的资料切割成多个字串，并将这些字串当成指定指令（预设为`/bin/echo`）执行时的参数。如果直接执行

```
xargs
```

接着在终端机中输入
```
arg1 arg2
arg3
```
    
结束时按下Ctrl+ d，这时候xargs就会把输入的两行资料切割成3个字串（分别为arg1、arg2与arg3），接着把这三个字串当作指定指令的参数，而这里我们没有指定任何指令，所以预设会使用/bin/echo，直接把三个字串输出至终端机中。

    arg1 arg2 arg3

这里虽然输入的资料中有包含一个换行字元（\n），不过因为xargs预设不会保留换行字元，所以整个输出就变成一整行。这个效果相当于

    /bin/echo arg1 arg2 arg3

xargs 在读取标准输入的资料时，会自动忽略空白行，多余的空白或是tab 字元也会自动被忽略。

如果要指定xargs所要执行的指令，可以直接将指令的名称放在所有xargs的参数之后，例如

    xargs cat
    arg1 arg2
    arg3

就相当于

    cat arg1 arg2 arg3

 
分隔字元
----
如果要指定xargs在读取标准输入时所使用的分隔字元，可以使用-d这个参数。例如：

    xargs -d\n
    arg1 arg2
    arg3

输出为

    arg1 arg2
    arg3

这里当我们使用-d这个参数指定分隔字元时，xargs就会将换行字元保留下来，所以输出会分为两行。

参数个数上限
---

预设的状况下，xargs会把从标准输入的资料所分割出来的字串，一次全部都放进指定指令参数中，例如：

    echo abcdef | xargs

就相当于

    echo abcdef

所以输出为

    abcdef

如果我们不想让所有的参数都放进一个指令中指令中执行，可以使用-n参数来指定每一次执行指令所使用的参数个数上限值，例如

    echo abcdef | xargs -n 3

就相当于

    echo abc
    echo def

所以输出就变为

    abc
    def

如果指定上限为2：

    echo abcdef | xargs -n 2

输出就会变成
    
    ab
    cd
    ef

 
执行前的确认
----
如果你对于xargs的使用方式不是很熟悉，或是需要以root权限执行一些不容出错的指令，可以加上-p参数，让指令在实际执行指令之前可以先进行确认的动作。例如：

    echo a b c d e f | xargs -p -n 3

则在每一行指令执行前，都会先确认，如果要执行就输入y，若不执行则输入n，假设每一个指令我们都输入y让它执行，则整个输出就会变成这样：

    /bin/echo abc ?...y
    /bin/echo def ?...abc
    y
    def

这里因为xargs的确认讯息与echo指令的输出混在一起，所以看起来有点奇怪。

如果所有的指令进行确认时，我们都输入n，这样就不会执行任何的echo指令，输出就会像这样：

    /bin/echo abc ?...n
    /bin/echo def ?...n
    /bin/echo ?...n

忽略空字串参数
----
大家应该有注意到上面的例子当我们使用 -p 参数时，如果所有的指令都输入n跳过不执行时，最后还会出现一个没有任何参数的 echo 指令，如果想要避免以这种空字串作为参数来执行指令，可以加上 -r 参数：

    echo a b c d e f | xargs -p -n 3 -r
    /bin/echo abc ?...n
    /bin/echo def ?...n

如果标准输入为空字串时，xargs预设还是会执行一次 echo 指令：

    xargs -p
    /bin/echo ?...n

这种状况同样可以加上-r参数：

    xargs -p -r

显示执行的指令
---
使用-t参数可以让xargs在执行指令之前先显示要执行的指令，这样可以让使用者知道xargs执行了哪些指令。

    xargs -t
    abcd

按下Ctrl+ d之后，xargs就会先输出要执行的指令内容，接着才是实际指令执行的输出，最后得到输出为

    /bin/echo abcd 
    abcd

结合xargs与find指令
----
xargs 本身的功能并不多，但是他跟其他的Linux 指令一起搭配使用时，功能就会显得很强大。

与find指令合在一起使用是xargs的一项非常重要的功能，它可以让你找寻特定的档案，并且进行特定的处理动作。

假设我们有一些资料夹，其中包含各式各样的档案，以tree指令查看目录结构会呈现

    .
    ├── folder1
    │ ├── file1.c
    │ ├── file1.h
    │ ├── file2.c
    │ └── file2.h
    └── folder2
        ├── file3.c
        └── file3.h
    
    2 directories, 6 files


假设我们想要找出目前路径之下的所有.c档案，并且将其删除，就可以使用

    find . -name "*.c" | xargs rm -f

这里我们将xargs要执行的指令指定为rm -f，让find所找到的.c档案都当成rm -f的参数，所以其指令的效果就相当于

    rm -f ./folder2/file3.c ./folder1/file2.c ./folder1/file1.c

如果你对于指令的操作还不是很熟悉，也可以配合上面介绍的-p参数，在执行前确认一下

    find . -name "*.c" | xargs -p rm -f

删除.c档案之后，以tree指令查看整个目录树就会变成

    .
    ├── folder1
    │ ├── file1.h
    │ └── file2.h
    └── folder2
        └── file3.h
    
    2 directories, 3 files


这里因为是示范用的例子，所以并没有建立太多的档案与目录结构，在实际的应用上，当整个目录结构很复杂、档案又很多的时候，使用这样的方式就会非常有效率。

包含空白的档案名称
----
假设我们的目录中有一些档名包含空白字元：

    touch "GT Wang.c"

在这种状况下如果用上面find与xargs的方式会无法将其删除，原因在于当我们执行

    find . -name "*.c" | xargs rm -f

的时候，xargs所产生的指令为

    rm -f ./GT Wang.c

因为档名包含空白，所以这会会造成rm指令无法正确删除该档案。

这个时候我们可以将`find`指令加上-print0参数，另外将xargs指令加上`-0`参数，改成这样
    
    # -p 交互
    find . -name "*.c" -print0 | xargs -0 rm -rf -p
    
`find -print0`表示在`find`的每一个结果之后加一个`NULL`字符，而不是默认加一个换行符。find的默认在每一个结果后加一个'\n'，所以输出结果是一行一行的。当使用了`-print0`之后，就变成一行了

然后`xargs -0`表示`xargs`用`NULL`来作为分隔符。这样前后搭配就不会出现空格和换行符的错误了。选择`NULL`做分隔符，是因为一般编程语言把`NULL`作为字符串结束的标志，所以文件名不可能以`NULL`结尾，这样确保万无一失。

如此一来，即可正确处理包含空白字元的档案名称。

命令列长度的限制
----
使用`--show-limits`参数可以查看系统对于命令列长度的限制，这些限制会跟xargs的运作情况有关，如果要处理很大量的资料时，这些限制要注意一下。

    xargs --show-limits

输出为

    Your environment variables take up 2022 bytes
    POSIX upper limit on argument length (this system): 2093082
    POSIX smallest allowable upper limit on argument length (all systems): 4096
    Maximum length of command we could actually use: 2091060
    Size of command buffer we are actually using: 131072
    
    Execution of xargs will continue now, and it will tr​​y to read its input and run commands; if this is not what you wanted to happen, please type the end-of-file keystroke.
    Warning: /bin/echo will be run at least once. If you do not want that to happen, then press the interrupt keystroke.

结合xargs与grep指令
----
xargs与grep两个指令的合并也是一个很常见的使用方式，它可以让你找寻特定档案之后，进而搜寻档案的内容。

假设我们要在所有的.c档案中搜寻stdlib.h这个字串，就可以使用

    find . -name '*.c' | xargs grep 'stdlib.h'

我直接拿VTK 的原始码来测试，输出会像这样

    ./CMake/TestOggTheoraSubsampling.c:#include <stdlib.h>
    ./Wrapping/Tools/lex.yy.c:#include <stdlib.h>
    ./Wrapping/Tools/vtkWrapPythonInit.c:#include <stdlib.h>
    ./Wrapping/Tools/vtkWrapTcl.c:#include <stdlib.h>
    ./Wrapping/Tools/vtkWrapTclInit.c:#include <stdlib.h>
    ./Wrapping/Tools/vtkParsePreprocess.c:#include <stdlib.h>
    ./Wrapping/Tools/vtkWrapText.c:#include <stdlib.h>
    ./Wrapping/Tools/vtkParseData.c:#include <stdlib.h>
    ./Wrapping/Tools/vtkParseHierarchy.c:#include <stdlib.h>
    ./Wrapping/Tools/vtkParseMain.c:#include <stdlib.h>
    [略]
这个对于程式设计师在看一堆专案原始码的时候特别有用。

例子
----

````bash
# -e 防转义 -d 设置 \t 为新的分割符
echo -e "a\tb\tv" | xargs -d "\t" echo # a b v
# xargs 处理完之后 ' ' 作为分割符,第二个 xargs 继续解析 
echo "a*b*c*d*e*f" | xargs -d* | xargs -d ' ' -I {} echo -{}-
# 执行命令,同时输出执行的命令
echo 'one two three' | xargs -t touch # touch one two three
echo 'one two three' | xargs -t rm  # rm one two three
# -d 指定分隔符
echo 'one two three' | xargs -d ' ' -I {} echo -{}-
# -one-
# -two-
# -three
# -
echo 'one two three' | xargs -I {} echo -{}-
# -one two three-

# 删除带有空格的文件夹
mkdir 'a b'
find . -maxdepth 1 -name "a*" -print0 | xargs -0 rm -rf

#  -L 指定多少行作为一个命令行参数
echo -e "a\nb\nc" | xargs -L 1 echo

# 每次将 n 项,作为命令行参数
echo -e "a\nb\nc" | xargs -n 1 echo

# --max-procs 表示不限制执行进程数
time echo "http://www.baidu.com http://ip.wlwz620.com" | xargs -n 1 --max-procs 0 curl
````


参考
-----
- [阮一峰 - xargs 命令教程](https://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html)
