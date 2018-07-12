![image](http://oj74t8laa.bkt.clouddn.com/md/http/827360-20160511130421515-1238552755.png)

1.TCP建立连接，三次握手
---

建立的TCP连接可靠的连接，必须经过三次握手建立连接才能正式通信彼此传输数数据。

客户端请求服务端建立连接

第一次握手：客户给服务发送一个请求报文SYN, 客户端的状态置SYN_SENT状态

第二次握手：服务端在收到客户端发过来的SYN请求报文后，开始给客户端发送ACK报文和SYN报文，状态置为SYN_RECE

第三次握手：客户端口收到服务端口过来的SYN报文和ACK报文后，状态由原来的SYN_SENT状态变为ESTABLISHED；并且给服务发送一个ACK报文告知对方已经送到服务端发送的SYN报文，服务端收到报文后，由原来的SYN_RECE变为ESTABLISHED

至此客户到服务端，服务端到客户端的双向连接建立好了并且处理ESTABLISHED。双方可以进行数据交换了。


2.TCP断开连接，四次挥手。
---

当客户端把所有数据传送完毕的时候，给服务端口送一个FIN报文，告知服务端：我这边没有数据可传，希望关闭客户端到服务端方向的连接。之后其状态由原来的

ESTABLISHED 变为FIN_WAIT_1,；

服务端收到客户的FIN报文后，送一个ACK报文给客户端，告知“我服务端知道你客户端口已经没有数据可传，但是我这边什么关闭连接，还需要等我的数据传完；如果我这里数据也传送完了，我也会给发送一个FIN报文。”。此时服务端发送ACK报文后，状态由之前的ESTABLISHED 变为CLOSE_WAIT

客户端端收到服务的ACK报文，将FIN_WAIT_1置FIN_WAIT_2,同时，继续等来的服务发送FIN报文。

当服务端数据传送也完毕的后，开始给客户端发送FIN包，发送FIN包后，其状态CLOSE_WAIT置为LAST_ACK

客户端口收到了服务的发过来的FIN包后，又给服务端发送ACK。发送ACK后，状态由原来的FIN_WAIT_2置为TIME_WAIT，客户在经过2MSL 时间进入CLOSE状态

服务端口收到客户端发送的ACK后，由LAST_ACK也进入CLOSE

3.TCP迁移状态：
---

LISTEN:服务端已经启动一个socket,其状态处于监听状态，等待客户发起请求连接。

ESTABLISHED:客户端和服务端经过三次握手建立，两个方向上连接状态都建立，状态置为ESTABLISHED

客户端状态变迁：（主动端）

FIN_WAIT_1: 发送FIN给服务端口。

FIN_WAIT_2:收到服务端的ACK报文

TIME_WAIT :收到服务端发过来的FIN报文，发送ACK报文给服务端口。主动关闭连接端，接收到服务（TIME_WAIT是主动端关闭）之后进入2MSL时间的等待

CLOSE：2MSl过后，关闭进入初始化状态。

 

服务端状态变迁：（服务端）

CLOSE_WAIT：收到客户端FIN报文，给客户端发送ACK状态后，表示知道客户端要关闭连接请求，服务端可能数据还没有传送完，所以处于等待关闭状态。（CLOSE_WAIT是被动端关闭）

LAST_ACK：服务端数据传输完毕，发送FIN报文给客户端，同时等待客户端发ACK报文状态

CLOSE：收到客户端ACK报文后，进入初始化状态

 

连接是双方建立的。发送数据的端客户也转变为接受数据的服务端口，服务端和客户角色是相互转换的

4.MSL时间：
---

MSL就是`maximum segment lifetime`(最大分节生命期），这是一个IP数据包能在互联网上生存的最长时间，超过这个时间IP数据包将在网络中消失 。MSL在RFC 1122上建议是2分钟，而源自berkeley的TCP实现传统上使用30秒

TIME_WAIT状态维持时间

TIME_WAIT状态维持时间是两个MSL时间长度，也就是在1-4分钟。Windows操作系统就是4分钟。

5.用于统计当前各种状态的连接的数量的命令
---

    netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'

返回结果如下：

    LAST_ACK 14
    SYN_RECV 348
    ESTABLISHED 70
    FIN_WAIT1 229
    FIN_WAIT2 30
    CLOSING 33
    TIME_WAIT 18122