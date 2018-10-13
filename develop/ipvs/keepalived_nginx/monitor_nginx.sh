#!/bin/bash 
if [ "$(ps -ef | grep "nginx: master process"| grep -v grep )" == "" ]
then 
    systemctl start nginx.service
    sleep 5   
  if [ "$(ps -ef | grep "nginx: master process"| grep -v grep )" == "" ] 
  then  
    killall keepalived 
  fi 
fi