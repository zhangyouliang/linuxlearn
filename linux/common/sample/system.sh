#!/usr/bin/env bash

#
# -------------------------------------------------------------
# 获取系统类型
# -------------------------------------------------------------
#
UNAME_PATH=`which uname`
PLAFORM=`$UNAME_PATH`

case $PLAFORM in
    HP-UX)
        OS=HP-UX;;
    AIX)
        OS=AIX;;
    SunOS)
        OS=SunOS;;
    Darwin)
        OS=Mac-OS;;
    Linux)
        if [ -s /etc/oracle-release ]; then
            OS=Oracle
        elif [ -s /etc/SuSE-release ]; then
            OS=SuSE
        elif [ -f /etc/centos-release ]; then
            OS=CentOS
        elif [ -s /etc/redhat-release ]; then
            OS=RedHat
        elif [ -r /etc/os-release ]; then
            grep 'NAME="Ubuntu"' /etc/os-release > /dev/null 2>&1
            if [ $? == 0 ]; then
                OS=Ubuntu
            fi
        else
            OS="Unknown Linux"
        fi ;;
    *)
        OS="Unknown Unix/Linux";;
esac

echo $OS

## 其他 方式
# 方式 1
#cat /etc/issue
# 方式 2
#
#lsb_release -a