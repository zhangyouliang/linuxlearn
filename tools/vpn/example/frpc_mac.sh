#!/user/bin/env bash

mkdir -p /usr/local/bin/frpc/
wget -O- https://github.com/fatedier/frp/releases/download/v0.37.1/frp_0.37.1_darwin_amd64.tar.gz | tar --strip-components 1 -xzC /usr/local/bin/frpc

# 请替换token
token=zhang2020#@!
server_addr=118.31.78.77

cat > /usr/local/bin/frpc/frpc.ini << EOF
[common]
server_addr = ${server_addr}
server_port = 7000
protocol = tcp
token=${token}

[vnc]
type = tcp
local_ip = 127.0.0.1
local_port = 5900
remote_port = 5900
use_encryption = true
use_compression = true

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
use_encryption = true
use_compression = true
EOF

cat >  ~/Library/LaunchAgents/frpc.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC -//Apple Computer//DTD PLIST 1.0//EN
http://www.apple.com/DTDs/PropertyList-1.0.dtd >
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>frpc</string>
    <key>ProgramArguments</key>
    <array>
     <string>/usr/local/bin/frpc/frpc</string>
         <string>-c</string>
     <string>/usr/local/bin/frpc/frpc.ini</string>
    </array>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# 加载并生效
# sudo chown root ~/Library/LaunchAgents/frpc.plist
# sudo launchctl load -w ~/Library/LaunchAgents/frpc.plist

launchctl load -w ~/Library/LaunchAgents/frpc.plist


# 清理工作
# launchctl unload -w ~/Library/LaunchAgents/frpc.plist
# rm -rf ~/Library/LaunchAgents/frpc.plist
# rm -rf /usr/local/bin/frpc/