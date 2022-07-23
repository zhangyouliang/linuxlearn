> mac 电脑休眠时,自动关闭 wifi,蓝牙
````
# 安装 
./install.sh
# 卸载
./uninstall.sh
````

原理: 利用 sleepwatcher 实现

```
# 使用brew安装sleepwatcher
brew install sleepwatcher
# 设置自启动
brew services start sleepwatcher
# 查看sleepwatcher进程是否启动
ps aux | grep sleepwatcher
# cd ~
touch .sleep
touch .wakeup
sudo chmod +x .sleep
sudo chmod +x .wakeup

写入测试代码

cat>.sleep<<EOF
/usr/local/bin/blueutil -p 0
networksetup -setairportpower en0 off
EOF

cat>.wakeup<<EOF
/usr/local/bin/blueutil -p 1
until networksetup -getairportpower en0 | grep On > /dev/null
do
	networksetup -setairportpower en0 on
	sleep 1
done
EOF

进入睡眠模式

sudo shutdown -s now

```