mac 局域网之间磁盘共享
====

服务端:
```
# 例如 我的局域网 ip 为 192.168.1.122 , workspace 为 共享目录
# -ro 只读权限  -rw 读写权限

cat >> /etc/exports <<EOF
V4: / -sec=sys
/Users/root/workspace -alldirs -ro -network 192.168.1.0 -mask 255.255.255.0
EOF



#确认NFSD服务开启
sudo nfsd enable 
#刷新NFSD共享资源
sudo nfsd update 
#显示当前共享的资源
showmount -e
```

客户端: (在需要挂载的电脑上面执行)

```

sudo mkdir -p /data/workspace
# 将服务器的目录挂载到本地 /data/workspace
sudo mount -o nolock,nfsvers=3,vers=3 -t nfs 192.168.1.122:/Users/root/workspace  /data/workspace
```

