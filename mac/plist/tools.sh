#!/bin/bash
set -e

file_name=xyz.hanks.spider.plist
bin_path=/opt/spider
log_path=/usr/local/var/log/spider
plist_path=~/Library/LaunchAgents/$file_name
case $1 in
    install )
        mkdir -p $bin_path && mkdir -p $log_path
        cp ./run.sh $bin_path && cp ./$file_name $plist_path
        launchctl load -w ~/Library/LaunchAgents/$file_name
        echo "查看状态:...."
        launchctl list | grep xyz
    ;;
    uninstall )
        launchctl unload -w ~/Library/LaunchAgents/$file_name
        ls $bin_path
        rm -ri $bin_path 
        ls $log_path
        rm -ri $log_path 
        ls $plist_path
        rm -ri $plist_path 
    ;;
    * )
        echo 'Usage: ./tools.sh {install | uninstall}'
    ;;
esac



