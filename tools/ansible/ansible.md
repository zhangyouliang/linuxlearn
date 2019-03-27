> Ansible是一个配置管理和配置工具
> [参考](https://ansible-tran.readthedocs.io/en/latest/docs/intro_inventory.html#id13)

安装
---

    apt-get install -y ansible
    # 或者
    pip install ansible

/etc/ansible/hosts

    [web]
    192.168.22.10
    192.168.22.11
    [local]
    127.0.0.1

    [remote]
    192.168.1.2

参数列表
---

    -i 设置库存文件,all: 是针对文件中定义的每个服务器运行的特殊关键字
    -m ping- 使用“ping”模块，它只是运行ping命令并返回结果
    -c local| --connection=local - 在本地服务器上运行命令，而不是SSH
    一些常用命令：
    -i PATH --inventory=PATH 指定host文件的路径，默认是在/etc/ansible/hosts
    --private-key=PRIVATE_KEY_FILE_PATH 使用指定路径的秘钥建立认证连接
    -m DIRECTORY --module-path=DIRECTORY 指定module的目录来加载module，默认是/usr/share/ansible
    -c CONNECTION --connection=CONNECTION 指定建立连接的类型，一般有ssh ，local
    -s sudo 运行
    -k, --ask-pass  提示输入 ssh 登录密码，当使用密码验证登录的时候用 
    -C check 只是测试一下会改变什么内容，不会真正去执行
    -u REMOTE_USER, --user=REMOTE_USER ssh   连接的用户名，默认用 root，ansible.cfg 中可以配置

    
    -m apt 使用 apt 模块将运行相同的命令
    -a "name=nginx state=installed update_cache=true" 提供apt模块的参数，包括软件包名称，所需的结束状态以及是否更新软件包存储库缓存




基础命令
---

    # 检查主机连接
    ansible web -m ping -u root
    # 执行远程命令
    ansible web -m command -a 'uptime'
    # 执行主控端脚本
    ansible web -m script -a '/etc/ansible/script/test.sh'
    # 执行远程主机的脚本
    ansible web -m shell -a 'ps aux|grep zabbix'
    # 复制文件到远程服务器
    ansible test -m copy -a "src=/etc/ansible/ansible.cfg dest=/tmp/ansible.cfg owner=root group=root mode=0644"
    # 指定主机
    ansible -i /etc/ansible/hosts all -m copy -a "src=test.conf dest=/etc/test.conf owner=root group=root mode=0644"

    # Debian / Ubuntu服务器上安装软件，“apt”模块将运行相同的命令
    B
    # Run against a local server
    ansible -i ./hosts local --connection=local -b --become-user=root \
        -m apt -a 'name=nginx state=installed update_cache=true'

    127.0.0.1 | success >> {
        "changed": false
    }

    # Run against a remote server
    ansible -i ./hosts remote -b --become-user=root \
        -m apt -a 'name=nginx state=installed update_cache=true'

    127.0.0.1 | success >> {
        "changed": false
    }
    
    # 安装程序
    ansible all -u root -m apt -a "name=sshpass state=installed"
    # 卸载程序
    ansible all -u root -m apt -a "name=sshpass state=removed"


Inventory
---
变量类型
- 主机变量
- 组变量
- 把一个组作为另一个组的子成员
- 分文件定义 Host 和 Group 变量

Inventory 参数的说明[参考:intro_inventory.html#id13](https://ansible-tran.readthedocs.io/en/latest/docs/intro_inventory.html#id13)

使用模板:

    /tmp/motd.j2
    Welcome, I am templated with a value of a={{ a }}, b={{ b }}, and c={{ c }}

    ansible webserver -m setup
    ansible webserver -m template -a "src=/tmp/motd.j2 dest=/etc/motd"

常用模块
---
> shell 和 command 的区别：shell 模块可以特殊字符，而 `command` 是不支持

> ansible 操作目标 -m 模块名 -a 模块参数

> 模块文档查看: ansible-doc 模块

* ping 测试模块
* setup  远程查看主机的配置信息
* command 远程执行命令
    * ansible hostname -m command -a "ls ~"
* raw 执行原始命令
    * ansible hostname -m raw -a "docker ps"   
* shell 远程节点执行模块
    * ansible hostname -m shell -a "ls ~"
* script 在远程执行本地脚本
    * ansible hostname -m script -a "~/test.sh"
* copy 复制模块
    * ansible hostname -m script -a "src=~/test.sh dest=~/scripts mode=0755"
* file 设置文件属性
* fetch 远程获取
* service 服务启动或者管理模块
* yum 软件安装模块
* user 用户管理
* mout 主机挂载模块
* sysctl 包管理模块