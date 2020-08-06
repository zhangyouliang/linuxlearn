## linux三种网络连接方式的区别

1、桥接：虚拟机通过本机的真实网卡和主机进行通讯。不仅可以和你的本机进行通讯，如果局域网内有同网段的计算机，也可以进行通讯。不过需要占用同网段的一个ip地址。

2、NAT：虚拟机通过VMware-8这块虚拟出来的网卡和你的本机进行通讯。

3、host-only：虚拟机通过VMware-1这块虚拟出来的网卡和你的本机进行通讯。

`NAT`和`host-only` 不会占用一个ip地址，只能和你的本机进行通讯。
`NAT`和`host-only`还有一个区别就是，host-only只能和你的本机进行通讯，不可以访问互联网。NAT除了只可以和你的本机进行通讯之外，如果你的本机可以访问互联网，你的虚拟机同样可以访问互联网。



参考
====

- [Linux 配置网络桥接](https://blog.csdn.net/jin1501997/article/details/81699874)
- [linux初学者-网络桥接篇](https://www.cnblogs.com/davidshen/p/8145965.html)
- [linux三种网络模式](https://www.cnblogs.com/liyue-sqsf/p/8991774.html)