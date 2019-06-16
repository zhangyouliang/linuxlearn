> diff 比较文件的不同

选项
---

GFMT 包含:

    %< 该行属于FILE1
    %> 该行属于FILE2
    %= 该行属于FILE1和FILE2公共行
    %[-][WIDTH（宽度）][.[PREC（精确度）]]{doxX}LETTER（字母） printf格式规范LETTER。如下字母表示属于新的文件，小写表示属于旧的文件：
        F 行组中第一行的行号

        L 行组中最后一行的行号

        N 行数（=L-F+1）

        E F-1

        M L+1
LFMT可包含：

    %L 该行内容

    %l 该行内容，但不包括尾随的换行符

    %[-][WIDTH][.[PREC]]{doxX}n printf格式规范输入行编号


例子
---

    # 以并列输出格式展示两个文件的不同
    diff -y t1.txt t2.txt

    this is a text!                           this is a text! 
    Name is t1.txt!                           | Name is t2.txt!
    The extra content!                        <
    I am MenAngel!                            <

    # 以上下文输出格式展示两个文件的不同
    diff -c  11.txt 22.txt
    *** 11.txt	2019-06-16 17:33:16.000000000 +0800
    --- 22.txt	2019-06-16 17:33:24.000000000 +0800
    ***************
    *** 1,5 ****  文件 11.txt 的 1~5
    --- 1,6 ----  文件 22.txt 的 1~6 不同之处
    bee
    dlv
    + example      文件 22.txt 多出来了 这一行
    fillstruct
    fresh
    gin
    ***************
    *** 24,28 ****
    --- 25,32 ----
    govendor
    guru
    impl
    + kratos
    + pcstat
    protoc-gen-go
    rtop
    + starlark

    # 以统一输出格式展示两个文件的不同
    diff -u t1.txt t2.txt
    --- t1.txt  2018-06-23 21:44:15.171207940 +0800　　　　//-代表t1.txt
    +++ t2.txt  2018-06-23 21:44:54.987207910 +0800　　　　//+代表t2.txt
    @@ -1,5 +1,3 @@　　　　//t1.txt第1行到第5行，t2.txt第1行到第3行
    this is a text!
    
    -Name is t1.txt!　　　　//-代表前面的文件比后面的文件多一行，+代表后面的文件比前面的文件多一行，一般一一对应
    -The extra content!
    -I am MenAngel!
    +Name is t2.txt!

    # 利用 vimdiff 拓展你,在 vim 中比较两个文件不同之处
    vimdiff 1.txt 2.txt