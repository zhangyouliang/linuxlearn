> medusa(美杜莎) 暴力破解密码

>[参考](https://blog.csdn.net/u010984277/article/details/50792816)


> Medusa是支持AFP, CVS, FTP, HTTP, IMAP, MS-SQL, MySQL, NCP (NetWare), 
NNTP, PcAnywhere, POP3, PostgreSQL, rexec, rlogin, rsh, SMB, SMTP 
(AUTH/VRFY), SNMP, SSHv2, SVN, Telnet, VmAuthd, VNC的密码爆破工具。

基本操作
---
    medusa [-h host|-H file] [-u username|-U file] [-p password|-P file] [-C file] -M module [OPT]

参数解释
---

    -h [TEXT]      目标IP
    -H [FILE]      目标主机文件
    -u [TEXT]      用户名
    -U [FILE]      用户名文件
    -p [TEXT]      密码
    -P [FILE]      密码文件
    -C [FILE]      组合条目文件
    -O [FILE]      文件日志信息
    -e [n/s/ns]    N意为空密码，S意为密码与用户名相同
    -M [TEXT]      模块执行名称
    -m [TEXT]      传递参数到模块
    -d             显示所有的模块名称
    -n [NUM]       使用非默认端口
    -s             启用SSL
    -r [NUM]       重试间隔时间，默认为3秒
    -t [NUM]       设定线程数量
    -L             并行化，每个用户使用一个线程
    -f             在任何主机上找到第一个账号/密码后，停止破解
    -q             显示模块的使用信息
    -v [NUM]       详细级别（0-6）
    -w [NUM]       错误调试级别（0-10）
    -V             显示版本
    -Z [TEXT]      继续扫描上一次

例子
---

查看可用模块
    
    medusa -d

查看模块帮助
    
    medusa -M mysql -q

猜测 mysql 数据库密码
    
    medusa -H ./ip.txt -u jfq -n 3306 -P ./pass.txt -e ns -M mysql -T 255 -f -O ./good.txt -r 0
    

参数解释
--
    -H 爆破的主机文件列表
    -u 爆破用户名
    -n 爆破端口
    -P 爆破使用密码
    -e ns 判断密码是否是空密码,还是账号密码一样.
    -M 使用模块的名字
    -T 可以简单的理解为线程数
    -f 一个ip爆破成功后,就停止该ip剩下的爆破.
    -O 保存成功的文件
    -r 0 重试间隔为0秒



