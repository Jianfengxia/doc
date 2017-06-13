#coding: utf-8

import MySQLdb
import os
import re

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

#打开oam数据库连接
db1 = MySQLdb.connect("10.1.134.60","root","@2015","oam",charset="utf8" )	
# 使用cursor()方法获取操作游标 
cursor1 = db1.cursor() 
#获取OAM未下架产品需监控的端口和主机IP
sql12="SELECT ip,port from v_zabbix_zabbixinfo where entity_id not in(SELECT entity_id from v_zabbix_productdown)"
cursor1.execute(sql12)
b1=cursor1.fetchall()
b=value_list(b1)

#获取OAM未下架产品需监控的主机IP	 
sql14="SELECT DISTINCT ip from v_zabbix_zabbixinfo where entity_id not in(SELECT entity_id from v_zabbix_productdown) ORDER BY updated DESC"
cursor1.execute(sql14)
bip1=cursor1.fetchall()
bip=value_list(bip1)

#获取OAM下架产品需监控的端口和主机IP
sql15="SELECT ip,port from v_zabbix_zabbixinfo where entity_id in(SELECT entity_id from v_zabbix_productdown)"
cursor1.execute(sql15)
bd1=cursor1.fetchall()
bd=value_list(bd1)

#获取OAM下架产品需监控的主机IP	 
sql16="SELECT DISTINCT ip from v_zabbix_zabbixinfo where entity_id in(SELECT entity_id from v_zabbix_productdown) ORDER BY updated DESC"
cursor1.execute(sql16)
bipd1=cursor1.fetchall()
bipd=value_list(bipd1)


	 
# 打开zabbix数据库连接
db2 = MySQLdb.connect("10.1.130.206","root","@2015","zabbix",charset="utf8" )
# 使用cursor()方法获取操作游标 
cursor2 = db2.cursor() 
#获取zabbix端口与IP监控信息
sql210="select b.host,a.key_ from items a,hosts b where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%' and a.hostid=b.hostid"
cursor2.execute(sql210)
a1=cursor2.fetchall()
a= value_zabbixportlist(a1) 
#获取zabbix端口监控ip信息
sql211="SELECT DISTINCT host from hosts where host LIKE '10%' or host LIKE'192%'"
cursor2.execute(sql211)
aip1=cursor2.fetchall()
aip= value_list(aip1)

#获取数据组数量
l1=len(a)
l2=len(b)
l3=len(aip)
l4=len(bip)
l5=len(bd)
l6=len(bipd)
#全局参数
i1=0
i2=0
i3=0
i4=0


#OAM运维平台新添加及变更产品端口监控添加到Zabbix
if l4<=l3:
 while i2<l4:
  if bip[i2] in aip:
   if l2<l1:
     while i1<l2:
      if b[i1] in a:
	     c=b[i1]	     		 
      else:
         c=b[i1]
         print u"未添加监控主机和端口",  c[0],c[1]
         port=c[1]
         hostname=c[0]
		 #获取zabbbix监控端口产品名称
         sql13="select value from catalog_product_entity_varchar where entity_id in (select entity_id from v_zabbix_zabbixinfo where port like '"+str(port)+"' and ip like '"+str(hostname)+"') and attribute_id like '71'"
         cursor1.execute(sql13)
         name_value=cursor1.fetchall()
         name=value(name_value)
		 #获取hostid数据
         sql21="SELECT `hostid` from `hosts` where `name` like  '" +hostname +"'"
         cursor2.execute(sql21)
         id = cursor2.fetchall()
         hostid = value(id)
		 #获取itemid数据
         sql22="select  itemid from items  order by itemid desc LIMIT 0,1"
         cursor2.execute(sql22)
         id = cursor2.fetchall()
         itemid1 = value(id)
         itemid=itemid1+1
         #插入端口监控
         sql23="insert into `items` (`itemid`,`hostid`,`name`,`key_`,`delay`,`formula`,`interfaceid`)values("+str(itemid)+","+str(hostid)+",concat('"+name+"port',"+str(port)+"),concat('net.tcp.port[','"+str(hostname)+"',',','"+str(port)+"',']'),'30','1','27')"
         #新建triggerid模板
         sql24="insert into triggers(triggerid)(select triggerid+'1' from triggers  order by triggerid desc LIMIT 0,1)"
         #插入表达式
         sql25="insert into functions(functionid,itemid,triggerid,function,parameter) (select a.functionid +'1',b.itemid,c.triggerid,'last','0' from functions as a ,items as b,triggers as c where b.itemid in (select b1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as b1) and c.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and a.functionid in (select a1.functionid from (select functionid from functions order by functionid desc LIMIT 0,1) as a1))"
         #更新报警
         sql26="update triggers a, functions b ,items as c set a.expression=concat('{',b.functionid, '}=0' ),a.priority= '5', a.description=concat( c.name,'is not runnning') where a.triggerid =b.triggerid and a.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and c.itemid =b.itemid"
         #新建报表graphs模板
         sql27="insert into graphs(graphid) (select graphid+'1' from graphs  order by graphid desc LIMIT 0,1)"
         #插入报表数据
         sql28="insert into graphs_items(gitemid,graphid,itemid)(select a.gitemid +'1',b.graphid,c.itemid from graphs_items a,graphs b,items c where a.gitemid in  (select a1.gitemid from ( select gitemid from graphs_items order by gitemid desc LIMIT 0,1)as a1) and b.graphid in  (select b1.graphid from ( select graphid from graphs order by graphid desc LIMIT 0,1)as b1) and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1) )"
         #更新报表graphs名称
         sql29="update graphs_items a,graphs b,items c set b.name =c.name where b.graphid=a.graphid and a.itemid =c.itemid and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1)"
         #执行sql语句
         cursor2.execute(sql23)
         cursor2.execute(sql24)
         cursor2.execute(sql25)
         cursor2.execute(sql26)
         cursor2.execute(sql27)
         cursor2.execute(sql28)
         cursor2.execute(sql29)
         db2.commit()
         print u"已添加监控产品、主机和端口", name,c[0],c[1]		 
      i1=i1+1
   else:
    print u"OAM平台监控端口数量过多"
  else:
   d=bip[i2]
   print u"OAM平台监控ip未添加到zabbix:",d[0]
   break
  i2=i2+1
else:
  print u"OAM平台监控ip数量过多" 

#下架产品删除zabbix端口监控
if l6<=l3:
 while i4<l6:
  if bipd[i4] in aip:
   if l5<l1:
     while i3<l5:
      if bd[i3] in a:
	     c=bd[i3]
             port=c[1]
             hostname=c[0]
             print u"下架产品需删除的监控主机和端口",  c[0],c[1]
             sql212="DELETE a.* from items a ,hosts b where b.host like '"+str(hostname)+"' and b.hostid=a.hostid and (a.key_ like concat('net.tcp.port[','"+str(hostname)+"',',','"+str(port)+"',']') or  a.key_ like concat('net.tcp.listen[','"+str(port)+"',']') or a.key_ like concat('net.tcp.listen[,','"+str(port)+"',']'))"
             cursor2.execute(sql212)
             db2.commit()
             print u"已删除监控主机和端口",  c[0],c[1]			 
      else:
         c=bd[i3]
         print u"下架产品已删除的监控主机和端口",  c[0],c[1]         				 
      i3=i3+1
   else:
    print u"OAM平台监控端口数量过多"
  else:
   d=bipd[i4]
   print u"OAM平台监控ip未添加到zabbix,不用删除监控的ip:",d[0]
   break
  i4=i4+1
else:
  print u"OAM平台监控ip数量过多" 


 

  
print u"Zabbix在线监控端口总数:",l1
print u"OAM在线监控端口总数:",l2 
print u"zabbix在线监控ip总数:",l3 
print u"OAM在线监控ip总数:",l4 
print u"OAM需下架监控端口总数:",l5 

# 关闭数据库连接
db1.close()
db2.close()

