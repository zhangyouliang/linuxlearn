#!/usr/bin/env bash

# export DEBUG=true

[[ -n "$DEBUG" ]] && set -x

########## color code ########
RED="31m"      # Error message
GREEN="32m"    # Success message
YELLOW="33m"   # Warning message
BLUE="36m"     # Info message

#########################

colorEcho(){
    # ${@:2} 参数截取,从 $2 开始
    echo -e "\033[${1}${@:2}\033[0m" 1>& 2
}


MAX_TIME_OUT=2.0

url=${url:-"http://dev.api.aidoukankan.com/api/monitor"}

Name=${Name:-"爱豆看看服务"}
Env=${Env:-"dev"}
API=${url}
Problem=${Problem:-"-"}
Detail=${Detail:-"-"}
TiggerTime=$(date +"%Y-%m-%d %H:%M:%S")

res=$(curl --connect-timeout 4 -m 5  -w "%{http_code}:%{time_total}" -so /dev/null ${url})
read -a arr <<< $(echo ${res} | tr ':' ' ')
#declare -p arr

Env=${Env:-"dev"}
echo $Env

# 发送钉钉
function sendDingDingMsg() {
    template=`cat << EOF
{
        "msgtype":"markdown",
        "markdown":{
            "title": "服务检测",
            "text": "**应用名称**: ${Name}

**环境**: ${Env}

**API**: ${API}

**问题**: ${1}

**详情**: ${Detail}

**时间**: ${TiggerTime}"
        }
    }
EOF`

curl 'https://oapi.dingtalk.com/robot/send?access_token=64594c7ec9a113d686d3e65cec52944a7e4e9c025d8c928b53911aedb4ade345' \
    -H 'Content-Type:application/json' \
    -d "${template}"
}


# 当状态码 != 200 是,退出
# [[ ${arr[0]} != 200 ]] && colorEcho ${RED} "curl ${url} , http_code ${arr[0]}" && exit 1
if [[ ${arr[0]} -ne 200 ]];then
#if [[ ${arr[0]} -eq 200 ]];then
   msg="curl ${url},http_code: ${arr[0]}"
   colorEcho ${RED} ${msg} && sendDingDingMsg "${msg}" && exit 0
fi

# 当超时时间超过 ${MAX_TIME_OUT} 时,退出脚本
#[[ `echo "${arr[1]} > ${MAX_TIME_OUT}" | bc` -eq 1  ]] && colorEcho ${RED} "curl ${url} , time_total >= ${MAX_TIME_OUT}" && exit 1
if [[ `echo "${arr[1]} > ${MAX_TIME_OUT}" | bc` -eq 1 ]]; then
    msg="curl ${url} , time_total >= ${MAX_TIME_OUT}"
    colorEcho ${RED} ${msg} && sendDingDingMsg "${msg}" && exit 0
fi





