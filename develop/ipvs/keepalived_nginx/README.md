keepalived + nginx 负载测试
-----

- keepalived_backup.conf  backup
- keepalived_master.conf  master 
- monitor_nginx.sh   检测脚本
- www.test.com.conf nginx 配置文件

> 这里有个超级坑的地方 `vrrp_script` 后面的 `{` 必须换行,否则无效

> 测试 ip:  172.17.8.150(master), 172.17.8.151 (backup), vip:  172.17.8.120

> 公钥请自行添加(机器自身的也需要添加)

hosts

    172.17.8.120  www.test0.com

/etc/ansible/hosts

    [master]
    172.17.8.150
    172.17.8.151

其他

    # 每个机器安装 
    # 辅助工具 
    apt install ansible
    # 主角
    apt install keepalived,ipvsadm,nginx

    # 文件复制
    scp ./keepalived_master.conf root@172.17.8.150:/etc/keepalived/keepalived.conf
    scp ./keepalived_backup.conf root@172.17.8.151:/etc/keepalived/keepalived.conf

    ansible all -m copy -a "src=./monitor_nginx.sh dest=/etc/keepalived/check_nginx.sh owner=root group=root mode=0644"
    ansible all -m copy -a "src=./www.test.com.conf dest=/etc/nginx/sites-enabled/www.test.com owner=root group=root mode=0644"
    # 启动服务
    ansible all -u root -m shell -a 'systemctl enable --now keepalived;systemctl enable --now nginx;'

    
    

