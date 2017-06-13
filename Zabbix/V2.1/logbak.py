#!/usr/bin/python
#coding: utf-8

import os
import time
import re
#获取时间
now=time.strftime('%Y%m%d%H%M%S',time.localtime(time.time()))
result='\n' + str(now) + '\n'
logfile="oamlog"+str(now)+""
                          
log1="tar cvzf oam.log.tar.gz oam.log"
log2='rm -rf oam.log'
log3='cp oam.log.bak oam.log'
log9="mkdir "+logfile+""
log7="mv oam.log.tar.gz "+logfile+""



log4=os.system(log1)
log5=os.system(log2)
log6=os.system(log3)
log10=os.system(log9)
log8=os.system(log7)


f = file(r'bak.log', 'a')
f.write(result)
f.write("日志备份\n")
f.write("备份状态"+str(log8))

f.close() 
