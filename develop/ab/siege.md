#### # 压力测试工具

> yum install siege

#### # 例子
 
    siege http://118.31.78.77:4003/getIp -c 100 -r 10
    
    siege  http://www.joedog.org/ POST haha=papa&dada=mama
    
    

#### # 参数

    -c 并发数
    -r 循环此处
    -f 使用文件
    -A "string", --agent="string"
    -H "header: value", --header="Header: value"
    -m "string", --mark="string"
    

    Transactions: 550 hits //完成550次处理
    Availability: 55.00 % //55.00 % 成功率
    Elapsed time: 31.32 secs //总共用时
    Data transferred: 1.15 MB //共数据传输1.15 MB
    Response time: 3.04 secs //显示网络连接的速度
    Transaction rate: 17.56 trans/sec // 每秒事务处理量
    Throughput: 0.04 MB/sec //平均每秒传送数据
    Concurrency: 53.44 //实际最高并发数
    Successful transactions: 433 //成功处理次数
    Failed transactions: 450 //失败处理次数
    Longest transaction: 15.50 //每次传输所花最长时间
    Shortest transaction: 0.42 //每次传输所花最短时间 
