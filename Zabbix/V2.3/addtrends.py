#!/usr/bin/python
#coding: utf-8

import MySQLdb
import os
import re
import time,datetime
import string
import smtplib
from email.mime.text import MIMEText
import sys
reload(sys)
sys.setdefaultencoding( "utf-8" )



#创建监控项数据函数
def value( val ):
    a = val[0]
    b = a[0]
    return b

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
     l1=len(a)
     b1=0
     while b1<l1:
        c=a[b1]
        g=list(c)
        d=g[1]
        e=re.findall(r'\d+',d,re.M)
        l2=len(e)
        b2=0
        h=[[1]]
        while b2<l2:
          i=[[]]
          j=[1,2]
          j[0]=g[0]
          c2=e[b2]
          j[1]=c2
          i[0]=j
          h=h+i
          b2=b2+1
        del a[b1]
        del h[0]
        a=h+a
        b1=b1+b2
        l1=l1+b2-1
     return a

     
     
#创建数据库数据转换列表函数
def value_list (val):
     a=list(val)
     l=len(a)
     b=0
     while b<l:
        c=a[b]
        g=list(c)
        a[b]=g
        b=b+1  
     return a

#创建发送邮件函数	 
def emaildown (useremail,name,ip,port,status,own):
   a=useremail
   b=name
   c=ip
   d=port
   e=status
   f=own
   
   #配置邮箱
   sender = 'POAM@fe.com'
   receiver = ''+a+',yonghua.liu@fe.com'
   receiver = string.splitfields(receiver, ",")
   subject = e+'【' + localtime + '】'
   smtpserver = 'm.fe.com'
   username = 'POAM'
   password = '!@#2015'

   #文件内容
   msg = MIMEText("<html><p style='color:#0099FF'><b>尊敬的运维工程师"+str(f)+"，您好：</b></p><p>&nbsp;&nbsp;产品名称："+str(b)+"</p><p>&nbsp;&nbsp;产品所在服务器IP："+str(c)+"</p><p><a>&nbsp;&nbsp;详细信息：该IP服务器未添加到zabbix监控里，请添加，错误请修改。</a><a href=""http://oam.fe.com:58080/index.php/admin/index""  style='color:#0099FF'><b>运维后台入口</b></a> </p><p>&nbsp;&nbsp;监控端口："+str(d)+"<br/>&nbsp;&nbsp;<br/>&nbsp;&nbsp;</p><p>&nbsp;&nbsp;ZABBIX监控</p></html>",'html','utf-8')

  #邮件头显示
   msg['Subject'] = subject
   msg['from'] = sender
   msg['to'] =  ','.join(receiver)

   #发送邮件
   try:
      smtp = smtplib.SMTP()
      smtp.connect('m.fe.com')
      smtp.login(username, password)
      smtp.sendmail(sender, receiver, msg.as_string())
      smtp.quit()
      print u"Successfully sent email"
   except Exception, e:  
      print str(e)

def email (useremail,name,ip,port,status,own):
   a=useremail
   b=name
   c=ip
   d=port
   e=status
   f=own
   
   #配置邮箱
   sender = 'POAM@fe.com'
   receiver = ''+a+',yonghua.liu@fe.com'
   receiver = string.splitfields(receiver, ",")
   subject = e+'【' + localtime + '】'
   smtpserver = 'm.fe.com'
   username = 'POAM'
   password = '!@#2015'

   #文件内容
   msg = MIMEText("<html><p style='color:#0099FF'><b>尊敬的运维工程师"+str(f)+"，您好：</b></p><p>&nbsp;&nbsp;产品名称："+str(b)+"</p><p>&nbsp;&nbsp;产品所在服务器IP："+str(c)+"</p><p>&nbsp;&nbsp;监控端口："+str(d)+"<br/>&nbsp;&nbsp;<br/>&nbsp;&nbsp;</p><p>&nbsp;&nbsp;ZABBIX监控</p></html>",'html','utf-8')

  #邮件头显示
   msg['Subject'] = subject
   msg['from'] = sender
   msg['to'] =  ','.join(receiver)

   #发送邮件
   try:
      smtp = smtplib.SMTP()
      smtp.connect('m.fe.com')
      smtp.login(username, password)
      smtp.sendmail(sender, receiver, msg.as_string())
      smtp.quit()
      print u"Successfully sent email"
   except Exception, e:  
      print str(e)



	  
#打开oam数据库连接
#db1 = MySQLdb.connect("10.1.134.60","root","@2015","oam",charset="utf8",init_command='set names utf8')	
# 使用cursor()方法获取操作游标 
#cursor1 = db1.cursor() 
#try:
#  p1=db1.ping()
#except:
#  print u"OAMmysql connect have been close"
# 打开zabbix数据库连接
db2 = MySQLdb.connect("10.1.130.206","root","@2015","zabbix",charset="utf8",init_command='set names utf8' )
# 使用cursor()方法获取操作游标 
cursor2 = db2.cursor() 
try:
  p2=db2.ping()
except:
  print u"zabbixmysql connect have been close"




#新增分区，删除历史数据

now_time = datetime.datetime.now()
error_time = now_time.strftime('%Y-%m-%d %H:%M:%S')
theday = (now_time + datetime.timedelta(days=+1)).strftime('%Y%m%d')
next_day = (now_time + datetime.timedelta(days=+2)).strftime('%Y-%m-%d')
last_time = (now_time - datetime.timedelta(days=30)).strftime('%Y%m%d')
last_time_month = datetime.datetime((now_time.year-1),now_time.month,now_time.day).strftime('%Y%m')
history_time = (now_time - datetime.timedelta(days=60)).strftime('%Y%m%d')
table_day=['history', 'history_uint']



print u"开始新增分区",error_time

for name_d in table_day:
   try:
   ####新增分区#######
      cursor2.execute('ALTER TABLE `%s` ADD PARTITION (PARTITION p%s VALUES LESS THAN (UNIX_TIMESTAMP("%s 00:00:00")))' % (name_d, theday, next_day))

   except MySQLdb.Error,e:
       print "[%s] Mysql Error %d: %s" % (error_time, e.args[0], e.args[1])
       pass

######清除history,histroy_uint表60天前的数据######
for name_d in table_day:
    try:
       cursor2.execute('ALTER TABLE `%s` DROP PARTITION p%s;' % (name_d, history_time))

    except MySQLdb.Error,e:
       print "[%s] Mysql Error %d: %s" % (error_time, e.args[0], e.args[1])
       pass
db2.commit()





#插入可用率数据

#获取开始时间
localtime1=time.localtime(time.time())
localtime = time.strftime('%Y-%m-%d %H:%M:%S',localtime1)
timestamp = int(time.mktime(localtime1))

print u"开始导入数据",localtime


#Zabbix


#查询所有监控端口itemid
sql201="select DISTINCT itemid from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%'"
cursor2.execute(sql201)
eid=cursor2.fetchall()
#eid= value_list(eid1)

#查询异常趋势图最后时间
sql202="SELECT clock from trends_port_low  ORDER BY clock  desc LIMIT 0,1"
cursor2.execute(sql202)
clock1=cursor2.fetchall()
clock= value(clock1)

#获取时间间隔次数
a=int(clock)
b=int(timestamp)
l2=(b-a)//3600

#获取数据组数量
l1=len(eid)

#全局参数
i1=0
i2=1

#插入每小时异常趋势数据

while (i2<=l2):
  for itemid1 in eid:
    itemid=itemid1[0]
    sql203="insert into `trends_port_low` (`itemid`,`clock`,`num`) (select '"+str(itemid)+"','"+str(clock+(3600*i2))+"',count(*) from history where itemid like '"+str(itemid)+"' and (clock>="+str(clock+(3600*i2))+") and (clock<="+str(clock+(3600*i2))+"+'3600') and value like '0.0000')"
    cursor2.execute(sql203)
    db2.commit()
  i2=i2+1


	
#获取结束时间
localtimelast1=time.localtime(time.time())
localtimelast = time.strftime('%Y-%m-%d %H:%M:%S',localtimelast1)
timestamplast = int(time.mktime(localtimelast1))
print u"结束导入数据",localtimelast
d=timestamplast-timestamp
e=d//3600
f=d%3600
g=f//60
i=f%60
print u"耗时： %d小时 %d分钟 %d 秒"%(e,g,i)
print u"循环次数",i2




# 关闭数据库连接
#db1.close()
db2.close()