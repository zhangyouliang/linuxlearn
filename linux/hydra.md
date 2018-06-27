> hydra(九头蛇) 是著名黑客组织thc的一款开源的暴力密码破解工具，可以在线破解多种密码。

命令参数
---

    hydra [[[-l LOGIN|-L FILE] [-p PASS|-P FILE]] | [-C FILE]] [-e ns]
    [-o FILE] [-t TASKS] [-M FILE [-T TASKS]] [-w TIME] [-f] [-s PORT] [-S] [-vV] server service [OPT]
    -R 继续从上一次进度接着破解。
    -S 采用SSL链接。
    -s PORT 可通过这个参数指定非默认端口。
    -l LOGIN 指定破解的用户，对特定用户破解。
    -L FILE 指定用户名字典。
    -p PASS 小写，指定密码破解，少用，一般是采用密码字典。
    -P FILE 大写，指定密码字典。
    -e ns 可选选项，n：空密码试探，s：使用指定用户和密码试探。
    -C FILE 使用冒号分割格式，例如“登录名:密码”来代替-L/-P参数。
    -M FILE 指定目标列表文件一行一条。
    -o FILE 指定结果输出文件。
    -f 在使用-M参数以后，找到第一对登录名或者密码的时候中止破解。
    -t TASKS 同时运行的线程数，默认为16。
    -w TIME 设置最大超时的时间，单位秒，默认是30s。
    -v / -V 显示详细过程。
    server 目标ip
    service 指定服务名，支持的服务和协议：telnet ftp pop3[-ntlm] imap[-ntlm] smb smbnt http-{head|get} http-{get|post}-form http-proxy cisco cisco-enable vnc ldap2 ldap3 mssql mysql oracle-listener postgres nntp socks5 rexec rlogin pcnfs snmp rsh cvs svn icq sapr3 ssh smtp-auth[-ntlm] pcanywhere teamspeak sip vmauthd firebird ncp afp等等。
    OPT 可选项

例子
---

    1、破解ssh：
    
    hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns ip ssh
    hydra -l 用户名 -p 密码字典 -t 线程 -o save.log -vV ip ssh
    
    2、破解ftp：
    
    hydra ip ftp -l 用户名 -P 密码字典 -t 线程(默认16) -vV
    hydra ip ftp -l 用户名 -P 密码字典 -e ns -vV
    
    3、get方式提交，破解web登录：
    
    hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns ip http-get /admin/
    hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns -f ip http-get /admin/index.php
    
    4、post方式提交，破解web登录：
    
    hydra -l 用户名 -P 密码字典 -s 80 ip http-post-form "/admin/login.php:username=^USER^&password=^PASS^&submit=login:sorry password"
    
    
    hydra -t 3 -l admin -P pass.txt -o out.txt -f 10.36.16.18 http-post-form "login.php:id=^USER^&passwd=^PASS^:<title>wrong username or password</title>"
    
    
    （参数说明：-t同时线程数3，-l用户名是admin，字典pass.txt，保存为out.txt，-f 当破解了一个密码就停止， 10.36.16.18目标ip，http-post-form表示破解是采用http的post方式提交的表单密码破解,<title>中的内容是表示错误猜解的返回信息提示。）
    
    5、破解https：
    
    hydra -m /index.php -l muts -P pass.txt 10.36.16.18 https
    
    6、破解teamspeak：
    
    hydra -l 用户名 -P 密码字典 -s 端口号 -vV ip teamspeak
    
    7、破解cisco：
    
    hydra -P pass.txt 10.36.16.18 cisco
    hydra -m cloud -P pass.txt 10.36.16.18 cisco-enable
    
    8、破解smb：
    
    hydra -l administrator -P pass.txt 10.36.16.18 smb
    
    9、破解pop3：
    
    hydra -l muts -P pass.txt my.pop3.mail pop3
    
    10、破解rdp：
    
    hydra ip rdp -l administrator -P pass.txt -V
    
    11、破解http-proxy：
    
    hydra -l admin -P pass.txt http-proxy://10.36.16.18
    
    12、破解imap：
    
    hydra -L user.txt -p secret 10.36.16.18 imap PLAIN
    hydra -C defaults.txt -6 imap://[fe80::2c:31ff:fe12:ac11]:143/PLAIN
