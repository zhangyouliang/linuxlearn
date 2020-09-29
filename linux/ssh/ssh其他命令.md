> ssh 相关命令

> [参考](http://www.zsythink.net/archives/2407)

ssh-copy-id
---
> 把本地主机的公钥复制到远程主机的`authorized_keys`文件上，`ssh-copy-id`命令也会给远程主机的用户主目录（home）和`~/.ssh`, 和`~/.ssh/authorized_keys`设置合适的权限。

> ssh-copy-id [-i [identity_file]] [user@]machine

    ssh-copy-id user@server
    ssh-copy-id -i ~/.ssh/id_rsa.pub user@server
    

ssh-keygen
---
> ssh-keygen命令用于为“ssh”生成、管理和转换认证密钥，它支持RSA和DSA两种认证密钥。

选项
--
    -b：指定密钥长度；
    -e：读取openssh的私钥或者公钥文件；
    -C：添加注释；
    -f：指定用来保存密钥的文件名；
    -i：读取未加密的ssh-v2兼容的私钥/公钥文件，然后在标准输出设备上显示openssh兼容的私钥/公钥；
    -l：显示公钥文件的指纹数据；
    -N：提供一个新密语；
    -P：提供（旧）密语；
    -q：静默模式；
    -t：指定要创建的密钥类型。
例子
    
     # 生成 id_rsa_test2 私钥,同时设置密码为 123456
     ssh-keygen -f ~/.ssh/id_rsa_test2 -P'123456'
     
     # 创建 test key
     ssh-keygen -f ~/.ssh/test -C "test key"
     
ssh-keyscan
---

ssh-keyscan命令是一个收集大量主机公钥的使用工具。

选项

    -4：强制使用IPv4地址；
    -6：强制使用IPv6地址；
    -f：从指定文件中读取“地址列表/名字列表”；
    -p：指定连接远程主机的端口；
    -T：指定连接尝试的超时时间；
    -t：指定要创建的密钥类型；
    -v：信息模式，打印调试信息。
    
    # 收集 xxx.xxx.xxx.xxx 机器的公钥信息
    ssh-keyscan xxx.xxx.xxx.xxx

ssh-agent
---

> [参考](http://www.zsythink.net/archives/2407)

那么什么时候需要ssh代理帮助我们管理私钥呢？当遇到如下情况时，我们会需要ssh代理。

- 1、使用不同的密钥连接到不同的主机时，需要手动指定对应的密钥，ssh代理可以帮助我们选择对应的密钥进行认证，不用手动指定密钥即可进行连接。
- 2、当私钥设置了密码，我们又需要频繁的使用私钥进行认证时，ssh代理可以帮助我们免去重复的输入密码的操作。
上述两种情况我们会一一道来，不过在描述它们之前，我们先来了解一下怎样使用ssh代理。

> 注意: `ssh-agent $SHELL` 会在当前shell中启动一个默认shell，作为当前shell的子shell，ssh-agent程序会在子shell中运行，当执行"ssh-agent $SHELL"命令后，我们也会自动进入到新创建的子shell中

> `ssh-add -l` 命令需要在 ssh-agent shell 当中执行,否则会出现 `The agent has no identities.`


***启动ssh-agent***

如下两种方式均可启动 `ssh-gent`


方式一：创建子shell，在子shell中运行ssh-agent进程，退出子shell自动结束代理。

    ssh-agent $SHELL

方式二：单独启动一个代理进程，退出当前shell时最好使用ssh-agent -k关闭对应代理

    eval `ssh-agent`

***关闭ssh-agent***

    ssh-agent -k
    
***将私钥添加到ssh代理***

    ssh-add ~/.ssh/key_name
    
***查看代理中的私钥***
    
     ssh-add -l

***查看代理中的私钥对应的公钥***
    
    ssh-add -L

***移除指定的私钥***
    
    ssh-add -d /path/of/key/key_name

***移除代理中的所有私钥***
    
    ssh-add -D

***锁定ssh代理***

锁定时需要指定锁定密码，锁定后的ssh代理暂时不能帮助我们管理私钥

    ssh-add -x
    
***解锁ssh代理***

解锁时需要输入创建锁时设定的密码，解锁后ssh代理可正常工作

    ssh-add -X
    
完整例子
----
    ## 生成 私钥 id_rsa_test2 密码为 123456
    ➜  ~ ssh-keygen -f ~/.ssh/id_rsa_test2 -P'123456'
    Generating public/private rsa key pair.
    Your identification has been saved in /root/.ssh/id_rsa_test2.
    Your public key has been saved in /root/.ssh/id_rsa_test2.pub.
    The key fingerprint is:
    SHA256:c6wVZKdxA2EWM6veIdZXH8TyHTvwfp+OUjqZrfI/r8E root@iZbp1irx58yxevjbcslavlZ
    The key's randomart image is:
    +---[RSA 2048]----+
    |          %++ .. |
    |         = O +.o |
    |          +   *.+|
    |         + . . *o|
    |        S * . . o|
    |       o B o.. ..|
    |        o . *E  +|
    |         . * oo..|
    |          oo=+=o |
    +----[SHA256]-----+
    ## 复制私钥到机器上面
    ➜  ~ ssh-copy-id -i ~/.ssh/id_rsa_test2.pub root@xxx.xxx.xxx.xxx
    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa_test2.pub"
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
    /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
    root@xxx.xxx.xxx.xxx's password: 
    
    Number of key(s) added: 1
    
    Now try logging into the machine, with:   "ssh 'root@xxx.xxx.xxx.xxx'"
    and check to make sure that only the key(s) you wanted were added.
    
    ## 由于使用默认的 id_rsa 文件,所以这里还是需要密码
    ➜  ~ ssh root@xxx.xxx.xxx.xxx                                   
    root@xxx.xxx.xxx.xxx's password: 
    
    # 不需要密码
    ➜  ~ ssh -i ~/.ssh/id_rsa_test2 root@xxx.xxx.xxx.xxx            
    Enter passphrase for key '/root/.ssh/id_rsa_test2': 
    Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-117-generic x86_64)
    
     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage
    
    Welcome to Alibaba Cloud Elastic Compute Service !
    
    Last login: Sun Jul 15 01:47:36 2018 from xxx.xxx.xxx.xxx
    root@rancher-master:~# exit
    logout
    Connection to xxx.xxx.xxx.xxx closed.
    ## 进去 ssh-agent
    ➜  ~ ssh-agent $SHELL                
    ## 查看(为空)                         
    ➜  ~ ssh-add -l                 
    The agent has no identities.
    ## 添加 id_rsa_test2 到 ssh-agent
    ➜  ~ ssh-add ~/.ssh/id_rsa_test2
    Enter passphrase for /root/.ssh/id_rsa_test2: 
    Identity added: /root/.ssh/id_rsa_test2 (/root/.ssh/id_rsa_test2)
    ## 连接目标主机,发现不再提示输入密码了
    ➜  ~ ssh root@xxx.xxx.xxx.xxx                       
    Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-117-generic x86_64)
    
     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage
    
    Welcome to Alibaba Cloud Elastic Compute Service !
    
    Last login: Sun Jul 15 02:12:53 2018 from xxx.xxx.xxx.xxx
    root@rancher-master:~# exit
    logout
    Connection to xxx.xxx.xxx.xxx closed.
    ## 进程查看(ssh-agent 属于 $SHELL 的其中一个子进程)
    ➜  ~ pstree -p | grep ssh-agent
               |                                                    `-ssh-agent(10715)
    ➜  ~ pstree -p | grep ssh      
               |-sshd(2056)---sshd(10082)---zsh(10103)---zsh(10714)-+-grep(10919)
               |                                                    `-ssh-agent(10715)
    ➜  ~ echo $$            
    10714
    ## 退出 ssh-agent 子进程
    ➜  ~ exit               
    ➜  ~ echo $$            
    10103
    ➜  ~ 
    