> nmap 端口扫描工具

> [参考](https://www.whatdy.com/articles/2018/04/linux-internet-security.html)

    nmap 118.31.78.77
    
    nmap -PS 118.31.78.77
    
    # 扫描一个ip 多个端口
    nmap 118.31.78.77 -p20-200,7777,8888
    
    # 扫描多个地址时排除文件里面的ip地址
    nmap 10.0.1.161-163  --excludefile ex.txt
    
    # 排除分散的,使用逗号分隔
    nmap 10.0.1.161-163 --exclude 10.0.1.161,10.0.1.163
    
    # 排除连续的，可以使用横线连接起来
    nmap 10.0.1.161-163 --exclude 10.0.1.162-163
    
    # 扫描文件中的ip
    nmap -iL ip.txt
    
    # 扫描一个子网网段所有ip
    nmap 10.0.3.0/24
    
    # 扫描开放ssh的机器
    nmap -sV -p22 -oG ssh 69.163.190.0/24
