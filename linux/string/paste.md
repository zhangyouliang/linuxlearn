> paste 用于将多个文件按照队列进行合并

语法
---
    paste (选项) (参数)

选项
--
    -d<间隔符号>

例子
--

    $ cat a.txt
    a
    b
    c
    $ cat b.txt
    1
    2
    3
    $ paste *.txt
    a 1 
    b 2
    c 3
    $ paste *.txt -d ','
    a,1 
    b,2
    c,3