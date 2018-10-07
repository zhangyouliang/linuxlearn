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

