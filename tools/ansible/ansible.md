> Ansible是一个配置管理和配置工具
> [参考](https://blog.csdn.net/pushiqiang/article/details/78126063)

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


