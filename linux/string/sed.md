> sed 文本替换

首处替换

    sed 's/text/replace_text/'  file // 替换每行的第一个匹配的 text

全局替换

    sed 's/text/replace_text/g' file

默认替换完后,输出替换的内容,如果需要替换文件里面的内容,需要添加 `-i`

    sed -i 's/text/replace_text/g' file

删除空白行

    sed '/^$/d' file
    

拓展:
     经常会删除空行和#头的行。而linux在删除空行的方法很多，grep、sed、awk、tr等工具都能实现。现总结如下：
     
     ^ 代表开头
     \ 转义
     * 重复匹配,代表匹配0次或者多次
     $ 代表行尾匹配
     d 删除
     \s 空格匹配


其他命令:

    # 匹配取反
    grep -v '^$' file
    
    # sed , -n 选项和 p命令一起使用表示只打印被替换的行
    # 如果这一行不为空格则开是位置都会存在一个 '.'
    sed '/^$/d' file 或者 sed -n '/./p' file
    

变量将转换: 已经匹配到的字符串通过标记 & 来引用

    echo this is en example | sed 's/\w+/[&]/g'
    [this]  [is] [en] [example]

子串匹配标记:第一个匹配的括号内容使用标记 1 来引用

    echo 'hello12121212' | sed 's/hello\([0-9]\)/\1/'
    12121212
   
    
    
    
