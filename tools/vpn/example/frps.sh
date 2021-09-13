#!/usr/bin/env bash

mkdir -p /opt/frp
mkdir -p /etc/frp
wget -O- https://github.com/fatedier/frp/releases/download/v0.37.1/frp_0.37.1_linux_amd64.tar.gz | tar --strip-components 1 -xzC /opt/frp



cp /opt/frp/frps /usr/bin/frps

# 请替换token
token=zhang2020#@!
# 编辑 frps.ini
cat > /etc/frp/frps.ini << EOF
[common]
bind_addr = 0.0.0.0
bind_port = 7000
token=${token}
EOF

cp /opt/frp/systemd/frps.service /lib/systemd/system/frps.service
# 重新加载配置
systemctl daemon-reload
# 启动 frps 开机启动
systemctl enable frps.service
# 启动 frps 
systemctl start frps.service


# 删除工作
# systemctl stop frps
# rm -rf /opt/frp