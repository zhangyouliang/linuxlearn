> wget 

    # 常用参数
    # 下载
    -O 保存为指定文件
    -O- 输出到屏幕
    -q 去除多余输出
    -limit-rate 限速下载
    -c 断点续传
    -spider 测试下载链接
    -i 一次下载多个文件    wget -i filelist.txt
    -t times 增加重试次数
    -reject 过滤指定格式 wget –reject=gif url 
    -o 下载信息存入日志文件 
    # 基础参数
    -b 后台运行
    # http options
    –user-agent 伪装代理名称下载
    
