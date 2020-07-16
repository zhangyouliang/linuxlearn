> read 读取文件,或者标准输入

选项
---

输入重定向命令`< file`会打开文件并执行读操作，并且会将读取的内容以标准输入的形式提供给read命令。


    -r 表示read将读取原生内容，所有字符都不会被转义，例如反斜线不会用于转义（只是反斜线）。
    -p 可以指定一个提示信息 例如:read -p "Enter your name:" name 
    -n 表示接受多少个字符
    -s 不输出到屏幕

例子
---

```
# 清空文件

:> file

# 读取文件的第一行并将其赋值给一个变量 
read -r line < file

# read命令会删除特殊变量IFS所表示的字符。IFS是Internal Field Separator（内部字段分隔符）的缩写，它的值为用于分隔单词和行的字符组成的字符串。IFS的默认值为空格符、制表符和换行符组成的字符串。这意味着前导和尾随的空格符和制表符都会被删除。如果你想保留这些字符，你可以将IFS设置为空字符：

IFS= read -r line < file

# 只有在这个命令执行过程中IFS值会改变，执行完后会重设为默认值。上面的命令绝对会读取第一行的原生内容，包含所有的前导和尾随的空白符。
# 另外一种将文件的一行内容读取到变量中的方法是：
line=$(head -1 file)

# 逐行读文件
while read -r line; do
    # do something with $line
done < file


while IFS= read -r line; do
    # do something with $line
done < file

# 或者
cat file | while IFS= read -r line; do
    # do something with $line
done

# 读取文件的前三列（前三个字段）并赋值给三个变量
read lines words chars file < <(wc read.md)
echo $lines $words $chars $file

```


