#coding: utf-8

import MySQLdb
import os
import re

#创建Zabbix监控IP和端口列表函数
def value_zabbixportlist (val):
     a=list(val)
     l=len(a)
     b=0
     while b<l:
        c=a[b]
        g=list(c)
        d=g[1]
        e=re.findall(r'\d+',d,re.M)
        f=e[-1]
        g[1]=f
        a[b]=g
        b=b+1  
     return a		
#创建OAM监控IP和端口列表函数
def value_oamportlist (val):
     a=list(val)
     l=len(a)
     b=0
     while b<l:
        c=a[b]
        g=list(c)
        a[b]=g
        b=b+1  
     return a

#打开oam数据库连接
db1 = MySQLdb.connect("10.1.134.60","root","@2015","oam",charset="utf8" )	
# 使用cursor()方法获取操作游标 
cursor1 = db1.cursor() 
sql12="SELECT ip,port from v_zabbix_zabbixinfo"
cursor1.execute(sql12)
b1=cursor1.fetchall()
b=value_oamportlist(b1)	 
	 
# 打开zabbix数据库连接
db2 = MySQLdb.connect("10.1.130.206","root","@2015","zabbix",charset="utf8" )
# 使用cursor()方法获取操作游标 
cursor2 = db2.cursor() 
sql210="select b.host,a.key_ from items a,hosts b where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%' and a.hostid=b.hostid"
cursor2.execute(sql210)
a1=cursor2.fetchall()
a= value_zabbixportlist(a1) 

l1=len(a)
l2=len(b)
i=0
if l2<l1:
   while i<l2:
      if b[i] in a:
	     c=b[i]
	     print u"已添加监控主机和端口：", c[0],c[1]
      else:
         c=b[i]
         print u"未添加监控主机和端口",  c[0],c[1]
      i=i+1
else:
   print u"OAM平台监控端口数量过多"


print u"Zabbix监控端口总数:",l1
print u"OAM监控端口总数:",l2 



