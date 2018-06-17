### sh  

set命令简介
---
set命令是shell中初学者比较少接触，但是却很有用的一个命令(这里我们说的shell指的是bash)。set命令是shell解释器的一个内置命令，用来设置shell解释器的属性，从而能够控制shell解释器的一些行为。

    ➜ ~/programming/test  $ type set
    set is a shell builtin
使用set命令
---
不带选项执行set命令
---
不带选项执行set命令时，会输出当前shell的所有变量，输出格式就和shell脚本里面的变量赋值的格式一样：name=value。因此，set命令的输出可以直接作为一个stdin的输入。

基本语法
set命令的基本语法如下（来自bash的man手册）：

       set [--abefhkmnptuvxBCEHPT] [-o option-name] [arg ...]
       set [+abefhkmnptuvxBCEHPT] [+o option-name] [arg ...]
set通过选项来开关shell的不同特性，每个特性都对应一个选项。每个特性都有两种配置方式：

一种是通过`set -e`和`set +e`这种形式，即直接指定选项。

另一种是通过`set -o errexit`和`set +o errexit`这种形式，即通过o这个选项来指定选项名。

我想你一定对选项是用+号还是-号十分好奇。在set命令中，选项前面跟着-号表示开启这个选项，+表示关闭这个选项。

选项介绍
---
 -o
 ---
执行set -o会输出当前的set选项配置情况：

    ~/programming/test$ set -o
    allexport       off
    braceexpand     on
    emacs           on
    errexit         off
    errtrace        off
    functrace       off
    hashall         on
    histexpand      on
    history         on
    ignoreeof       off
    interactive-comments    on
    keyword         off
    monitor         on
    noclobber       off
    noexec          off
    noglob          off
    nolog           off
    notify          off
    nounset         off
    onecmd          off
    physical        off
    pipefail        off
    posix           off
    privileged      off
    verbose         off
    vi              off
    xtrace          off
+o
---

执行`set +o` 也是输出当前的set选项的配置情况，只不过输出形式是一系列的set命令。这种输出形式一般用于重建当前的set配置项时使用。

    ~/programming/test$ set +o
    set +o allexport
    set -o braceexpand
    set -o emacs
    set +o errexit
    set +o errtrace
    set +o functrace
    set -o hashall
    set -o histexpand
    set -o history
    set +o ignoreeof
    set -o interactive-comments
    set +o keyword
    set -o monitor
    set +o noclobber
    set +o noexec
    set +o noglob
    set +o nolog
    set +o notify
    set +o nounset
    set +o onecmd
    set +o physical
    set +o pipefail
    set +o posix
    set +o privileged
    set +o verbose
    set +o vi
    set +o xtrace
-e or -o errexit
---
设置了这个选项后，当一个命令执行失败时，shell会立即退出。

-n or -o noexec
---
设置了这个选项后，shell读取命令，但是不会执行它们。这个选项可以用来检查shell脚本是否存在语法错误。

-u or -o unset
---
设置了这个选项之后，当shell要扩展一个还未设置过值的变量时，shell必须输出信息到stderr，然后立即退出。但是交互式shell不应该退出。

-x or -o xtrace
---
设置了这个选项之后，对于每一条要执行的命令，shell在扩展了命令之后（参数扩展）、执行命令之前，输出trace到stderr。

-o pipefail
---
这个选项会影响管道的返回值。默认情况下，一个管道的返回值是最后一个命令的返回值，比如`cmda | cmdb | cmdc`这个管道，返回值是由cmdc命令的返回值决定的。如果指定了pipefail选项，那么管道的返回值就会由最后一个失败的命令决定，意思就是有命令失败就会返回非0值。如果所有命令都成功，则返回成功。

例子

    #!/bin/bash

    set -o xtrace
    set -o errexit  # 可以把这样注释掉看下执行效果有什么不一样。
    
    echo "Before"
    ls filenoexists  # ls也不存在的文件
    echo "After"
更多
----
本文介绍的只是set命令的常用部分，更多的选项可以参考官方文档或者bash的man手册。官方文档地址是：

http://pubs.opengroup.org/onlinepubs/009695399/utilities/set.html

