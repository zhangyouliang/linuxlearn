> egrep命令用于在文件内查找指定的字符串。egrep执行效果与`grep -E`相似，使用的语法及参数可参照grep指令，与grep的不同点在于解读字符串的方法。

语法
---

    egrep(选项)(查找模式)(文件名1，文件名2，……)
    
    
实例
---

显示文件中符合条件的字符。例如，查找当前目录下所有文件中包含字符串"Linux"的文件，可以使用如下命令：

    egrep Linux *


过滤文集中的 注释(#),以及空行

    egrep  -v "^#|^$" goaccess.conf


example.txt

        Lorem ipsum
        dolor sit amet, 
        consetetur
        sadipscing elitr,
        sed diam nonumy
        eirmod tempor
        invidunt ut labore
        et dolore magna
        aliquyam erat, sed
        diam voluptua. At
        vero eos et
        accusam et justo
        duo dolores et ea
        rebum. Stet clita
        kasd gubergren,
        no sea takimata
        sanctus est Lorem
        ipsum dolor sit
        amet.


        $ egrep '(Lorem|dolor)' example.txt
        or
        $ grep -E '(Lorem|dolor)' example.txt
        Lorem ipsum
        dolor sit amet,
        et dolore magna
        duo dolores et ea
        sanctus est Lorem
        ipsum dolor sit