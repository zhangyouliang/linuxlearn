> crunch 生成密码词典
> [参考](https://blog.csdn.net/wjy397/article/details/73864332)

命令参数
---
	-b              #体积大小，比如后跟20mib
	-c              #密码个数（行数），比如8000
	-d              #限制出现相同元素的个数（至少出现元素个数），-d 3就不会出现zzf  ffffgggg之类的
	-e              #定义停止生成密码 ，比如-e 222222：到222222停止生成密码
	-f               #调用密码库文件，比如/usr/share/crunch/charset.lst
	-i               #改变输出格式
	-l               #与-t搭配使用
	-m               #与-p搭配使用
	-o               #保存为
	-p               #定义密码元素
	-q               #读取字典
	-r               #定义从某一个地方重新开始
	-s               #第一个密码，从xxx开始
	-t               #定义输出格式
	                 @代表小写字母
	                 ,代表大写字母    
	                 %代表数字
	                 ^代表符号
	-z               #打包压缩，格式支持 gzip, bzip2, lzma, 7z


案例
---

	# 生成密码词典
	crunch 8 9 abcd -o ./hello.txt

	crunch 1 8
	#生成最小1位，最大8位，由26个小写字母为元素的所有组合

	crunch 1 6 abcdefg
	#生成 最小为1,最大为6.由abcdefg为元素的所有组合

	crunch 1 6 abcdefg\
	#生成 最小为1,最大为6.由abcdefg和空格为元素的所有组合（/代表空格）


	#调用密码库 charset.lst， 生成最小为1，最大为8,元素为密码库 charset.lst中 mixalpha-numeric-all-space的项目，并保存为 wordlist.txt；其中 charset.lst在kali_linux的目录为 /usr/share/crunch/charset.lst， charset.lst中 mixalpha-numeric-all-space项目包含最常见的元素组合（即大小写字母+数字+常见符号）；
>想了解更多可以cat /usr/share/crunch/charset.lst 查看所有密码库

	crunch 8 8 -f charset.lst mixalpha-numeric-all-space -o wordlist.txt -t @@dog @@@ -s cbdogaaa
	#调用密码库 charset.lst，生成8位密码；其中元素为 密码库 charset.lst中 mixalpha-numeric-all-space的项；格式为“两个小写字母+dog+三个小写字母”，并以cbdogaaa开始枚举（@代表小写字母）

	crunch 2 3 -f charset.lst ualpha -s BB
	#调用密码库charset.lst，生成2位和3位密码；其中元素为密码库charset.lst中ualpha的项；并且以BB开头

	crunch 4 5 -p abc
	#crunch将会生成abc, acb, bac, bca, cab, cba，虽然数字4和5这里没用，但必须有

	crunch 1 5 -o START -c 6000 -z bzip2 
	# 生成最小为1位，最大为5位元素为所有小写字母的密码字典，其中每一个字典文件包含6000个密码，并将密码文件保存为bz2文件，文件名将以  "第一个密码" + " - " + "最后一个密码" + " .txt.bz2 " 保存（比如000-999.txt.bz2）；

	crunch 4 5 -b 20mib -o START
	# 生成最小为4位，最大为5位元素为所有小写字母的密码字典，并以20M进行分割；这时会生成4个文件：aaaa-gvfed.txt,  gvfee-ombqy.txt,  ombqz-wcydt.txt, wcydu-zzzzz.txt：其中前三个大概每个20M，最后一个10M左右（因为总共70M）

	crunch 4 4  + + 123 + -t %%@^
	#生成4位密码，其中格式为“两个数字”+“一个小写字母”+“常见符号”（其中数字这里被指定只能为123组成的所有2位数字组合）。比如12f#      32j^    13t$    ......
 

	crunch 8 8 -d 2@
	#生成8位密码，每个密码至少出现两种字母

	
	crunch 4 4 -f unicode_test.lst the-greeks -t @@%% -l @xdd
	#调用密码库 unicode_test.lst中的 the-greeks项目字符，生成4位密码，其中格式为两小写字母+两数字，同样kali_linux中 unicode_test.lst 在/usr/share/crunch目录

	crunch 10 10 -t @@@^%%%%^^ -d 2@ -d 3% -b 20mb -o START
	#生成10位密码，格式为三个小写字母+一个符号+四个数字+两个符号，限制每个密码至少2种字母和至少3种数字


	crunch 5 5 -s @4#S2 -t @%^,% -e @8 Q2 -l @dddd -b 10KB -o START
	#生成5位密码，格式为小写字母+数字+符号+大写字母+数字，并以 @4#S2开始，分割为10k大小。。。



