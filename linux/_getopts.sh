#!/usr/bin/env bash

# ./test.sh -a "000000000000000000000000" -f http://dev.api.aidoukankan.com

set -e
set -o pipefail

cmd=$(basename $0)
systemName=$(uname -s)

if which getopt &>/dev/null; then
    optExist="true"
fi

Usage(){
    echo "帮助说明"
    echo "这个脚本如何使用，如参数 a f  h 后面跟什么值，或者长参数appid fusion help 后面跟什么值"
}

if [[ "${optExist}"x = "true"x ]]; then

    if [[ ${systemName} == 'Darwin' ]]; then
        ARGS="$@ --"
    elif [[ ${systemName} == 'Linux' ]];then
        ARGS=$(getopt -o "a:f:h" -l "appid:,fusion:,help" -n "${cmd}" -- "$@")
    fi
    eval set -- "${ARGS}"

    while true;do
        case "${1}" in
        -a|--appid)
        shift;
        if [[ -n "${1}" ]]; then
            appid="${1}"
            shift;
        fi
        ;;
        -f|--fusion)
        shift;
        if [[ -n "${1}" ]]; then
            fusion=${1}
            shift;
        fi
        ;;
        -h|--help)
        Usage
        exit 0
        ;;
        --)
        shift ;
        break ;
        ;;
        *)
        Usage
        exit 0
        ;;
       esac
    done
else
    while getopts a:f:h opt;do
    case $opt in
    a)
    appid=$OPTARG
    ;;
    f)
    fusion=$OPTARG
    ;;
    h)
    Usage
    exit 0
    ;;
    ?)
    Usage
    exit 1
    ;;
    esac
    done
fi

if [[ ! $appid =~ [0-9a-fA-F]{24} ]]; then
    echo -e "\033[1;41;37mInvalid appid!\033[0m\n"
    Usage
    exit 1
fi

if [[ ! $fusion =~ ^http:// ]]; then
    fusion="http://${fusion}"
fi

echo -e "\033[32mSending request...\033[0m"
# curl -H "Content-Type:application/json" -X PUT --data "{\"app_id\": \"$appid\"}"  "$fusion/api/tasks"
curl -X GET "$fusion/api/tasks"
echo -e "\033[32mFinished!\033[0m"
exit 0
