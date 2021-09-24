> hping 是用于生成和解析TCPIP协议数据包的开源工具。创作者是Salvatore Sanfilippo。目前最新版是hping3，支持使用tcl脚本自动化地调用其API。hping是安全审计、防火墙测试等工作的标配工具。hping优势在于能够定制数据包的各个部分，因此用户可以灵活对目标机进行细致地探测。
  

选项
---
    -H --help 显示帮助。
    -v -VERSION 版本信息。
    -c --count count 发送数据包的次数 关于countreached_timeout 可以在hping2.h里编辑。
    -i --interval 包发送间隔时间（单位是毫秒）缺省时间是1秒,此功能在增加传输率上很重要,在idle/spoofing扫描时此功能也会被用到,你可以参考hping-howto获得更多信息-fast 每秒发10个数据包。
    -n -nmeric 数字输出，象征性输出主机地址。
    -q -quiet 退出。
    -I --interface interface name 无非就是eth0之类的参数。
    -v --verbose 显示很多信息，TCP回应一般如：len=46 ip=192.168.1.1 flags=RADF seq=0 ttl=255 id=0 win=0 rtt=0.4ms tos=0 iplen=40 seq=0 ack=1380893504 sum=2010 urp=0
    -D --debug 进入debug模式当你遇到麻烦时，比如用HPING遇到一些不合你习惯的时候，你可以用此模式修改HPING，（INTERFACE DETECTION,DATA LINK LAYER ACCESS,INTERFACE SETTINGS,.......）
    -z --bind 快捷键的使用。
    -Z --unbind 消除快捷键。
    -O --rawip RAWIP模式，在此模式下HPING会发送带数据的IP头。
    -1 --icmp ICMP模式，此模式下HPING会发送IGMP应答报，你可以用--ICMPTYPE --ICMPCODE选项发送其他类型/模式的ICMP报文。
    -2 --udp UDP 模式，缺省下，HPING会发送UDP报文到主机的0端口，你可以用--baseport --destport --keep选项指定其模式。
    -9 --listen signatuer hping的listen模式，用此模式，HPING会接收指定的数据。
    -a --spoof hostname 伪造IP攻击，防火墙就不会记录你的真实IP了，当然回应的包你也接收不到了。
    -t --ttl time to live 可以指定发出包的TTL值。
    -H --ipproto 在RAW IP模式里选择IP协议。
    -w --WINID UNIX ,WINDIWS的id回应不同的，这选项可以让你的ID回应和WINDOWS一样。
    -r --rel 更改ID的，可以让ID曾递减输出，详见HPING-HOWTO。
    -F --FRAG 更改包的FRAG，这可以测试对方对于包碎片的处理能力，缺省的“virtual mtu”是16字节。
    -x --morefrag 此功能可以发送碎片使主机忙于恢复碎片而造成主机的拒绝服务。
    -y -dontfrag 发送不可恢复的IP碎片，这可以让你了解更多的MTU PATH DISCOVERY。
    -G --fragoff fragment offset value set the fragment offset
    -m --mtu mtu value 用此项后ID数值变得很大，50000没指定此项时3000-20000左右。
    -G --rroute 记录路由，可以看到详悉的数据等等，最多可以经过9个路由，即使主机屏蔽了ICMP报文。
    -C --ICMPTYPE type 指定ICMP类型，缺省是ICMP echo REQUEST。
    -K --ICMPCODE CODE 指定ICMP代号，缺省0。
    --icmp-ipver 把IP版本也插入IP头。
    --icmp-iphlen 设置IP头的长度，缺省为5（32字节）。
    --icmp-iplen 设置IP包长度。
    --icmp-ipid 设置ICMP报文IP头的ID，缺省是RANDOM。
    --icmp-ipproto 设置协议的，缺省是TCP。
    -icmp-cksum 设置校验和。
    -icmp-ts alias for --icmptype 13 (to send ICMP timestamp requests)
    --icmp-addr Alias for --icmptype 17 (to send ICMP address mask requests)
    -s --baseport source port hping 用源端口猜测回应的包，它从一个基本端口计数，每收一个包，端口也加1，这规则你可以自己定义。
    -p --deskport [+][+]desk port 设置目标端口，缺省为0，一个加号设置为:每发送一个请求包到达后，端口加1，两个加号为：每发一个包，端口数加1。
    --keep 上面说过了。
    -w --win 发的大小和windows一样大，64BYTE。
    -O --tcpoff Set fake tcp data offset. Normal data offset is tcphdrlen / 4.
    -m --tcpseq 设置TCP序列数。
    -l --tcpck 设置TCP ack。
    -Q --seqnum 搜集序列号的，这对于你分析TCP序列号有很大作用。


Hping3功能
---





