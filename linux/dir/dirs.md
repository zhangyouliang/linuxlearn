> dirs,pushd,popd 的妙用 

命令参数
---

- dirs :  显示当前目录栈中的所有记录（不带参数的dirs命令显示当前目录栈中的记录）
> 注意：dirs始终显示当然目录, 再是堆栈中的内容；即使目录堆栈为空, dirs命令仍然只显示当然目录
````
-c    删除目录栈中的所有记录
-l     以完整格式显示
-p    一个目录一行的方式显示
-v    每行一个目录来显示目录栈的内容，每个目录前加上的编号
+N  显示从左到右的第n个目录，数字从0开始
-N   显示从右到左的第n个日录，数字从0开始
````

- pushd: pushd 命令常用于将目录加入到栈中，加入记录到目录栈顶部，并切换到该目录；若pushd命令不加任何参数，则会将位于记录栈最上面的2个目录对换位置
> 将该目录加入到栈顶，并执行"cd 目录"，切换到该目录
````
+N   将第N个目录移至栈顶（从左边数起，数字从0开始）
-N    将第N个目录移至栈顶（从右边数起，数字从0开始）
-n    将目录入栈时，不切换目录
````


- popd:  popd用于删除目录栈中的记录；如果popd命令不加任何参数，则会先删除目录栈最上面的记录，然后切换到删除过后的目录栈中的最上面的目录
> 当前目录处于栈顶,popd 删除栈顶,然后切换到删除过后的目录栈中的最上面的目录
````
+N   将第N个目录删除（从左边数起，数字从0开始）
-N    将第N个目录删除（从右边数起，数字从0开始）
-n    将目录出栈时，不切换目录
````


案例
---



参考
---
