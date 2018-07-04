#!/usr/bin/env python3
# -*- coding: utf-8 -*-
__author__ = "zhangyouliang"

from scapy.all import *
import sys,time


iface='en0'
if len(sys.argv) >=2:
    iface = sys.argv[1]

s = RandString(RandNum(1,10))
s1 = s.lower().decode('utf-8')

d=RandString(RandNum(1,10))
s2=d.lower().decode('utf-8')

t=RandString(RandNum(2,3))
s3=t.lower().decode('utf-8')

q = '.'.join([s1,s2,s3])
print(1)




# i = 5
# while(i):
#     print(RandMAC())
#     print(RandIP())
#     i = i-1
#     # 生成固定ip端
#     print(RandIP("192.168.1.*"))
