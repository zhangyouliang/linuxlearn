> Nginx (engine x) 是一个高性能的HTTP和反向代理服务器，也是一个IMAP/POP3/SMTP服务器

nginx 日志
---


    log_format  main  '"$http_x_forwarded_for" |  "$request_time" | "$upstream_response_time" | $remote_addr | $remote_user | [$time_local] | "$request" | '
                                 '$status | $body_bytes_sent | "$http_referer"  | "$http_user_agent" ';
    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log;



## 参考

[Nginx内置变量以及日志格式变量参数详解](https://www.cnblogs.com/wajika/p/6426270.html)

[nginx记录响应与POST请求日志](http://www.ttlsa.com/nginx/nginx-post-response-log/)
