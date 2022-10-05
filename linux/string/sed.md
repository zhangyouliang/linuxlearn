> sed 文本替换


语法
---

````
-e 脚本, --expression=脚本   添加“脚本”到程序的运行列表
-f 脚本文件, --file=脚本文件  添加“脚本文件”到程序的运行列表
-i[扩展名], --in-place[=扩展名]    直接修改文件(如果指定扩展名就备份文件)
-l N, --line-length=N   指定“l”命令的换行期望长度
--posix  关闭所有 GNU 扩展
-r, --regexp-extended  在脚本中使用扩展正则表达式
-s, --separate  将输入文件视为各个独立的文件而不是一个长的连续输入
-u, --unbuffered  从输入文件读取最少的数据，更频繁的刷新输出
-n, --quiet, --silent    取消自动打印模式空间
--follow-symlinks    直接修改文件时跟随软链接
--help     打印帮助并退出
--version  输出版本信息并退出

# 动作
a ∶新增， a 的后面可以接字串，而这些字串会在新的一行出现(目前的下一行)～
c ∶取代， c 的后面可以接字串，这些字串可以取代 n1,n2 之间的行！
d ∶删除，因为是删除啊，所以 d 后面通常不接任何咚咚；
i ∶插入， i 的后面可以接字串，而这些字串会在新的一行出现(目前的上一行)；
p ∶列印，亦即将某个选择的资料印出。通常 p 会与参数 sed -n 一起运作～
s ∶取代，可以直接进行取代的工作哩！通常这个 s 的动作可以搭配正规表示法
````


实例
---

首处替换

    sed 's/text/replace_text/'  file // 替换每行的第一个匹配的 text

追加

     sed '/text/i\append_text' file // 在 text 的下一行追加 append_text

插入

     sed '/text/i\insert_text' file // 在 text 的上一行插入 insert_text


全局替换

    sed 's/text/replace_text/g' file

默认替换完后,输出替换的内容,如果需要替换文件里面的内容,需要添加 `-i`

    sed -i 's/text/replace_text/g' file

删除空白行

    sed '/^$/d' file

需要转移的字符:

- " 转移为 \"
- . 可以转移也可以不转移
- / 转移为 \/

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
   
    
文件批量重命名去除空格

````bash
# 矢量 4.png ===> 4.png
for var in `ls`;do
    i=$(($i+1));mv "$var" $(sed 's/.*[[:blank:]]//' <<< "$var") 
done
````
    
    
