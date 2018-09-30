wrk.method = "GET"
wrk.headers["Content-Type"] = "application/x-www-form-urlencoded"
wrk.body = ""
-- 参考: https://type.so/linux/lua-script-in-wrk.html
-- lua还提供了几个函数   
-- setup 函数 、init 函数 、delay函数、request函数 、response函数、done函数。
function response(status,headers,body)
    t = os.date("%Y-%m-%d %H:%M:%S", os.time())
    print("body:",body,t)
end
