#coding: utf-8

import MySQLdb
import os

#������������ݺ���
def value( str ):
    a = str[0]
    b = a[0]
    return b	

#��ȡ����IP
hostname = raw_input("��������ip: ");
#��ȡ��ض˿�
port = raw_input("�����ض˿�: ");

# �����ݿ�����
db = MySQLdb.connect("10.1.130.206","root","@2015","zabbix" )
# ʹ��cursor()������ȡ�����α� 
cursor = db.cursor() 
# SQL ��ѯ���
sql1="SELECT `hostid` from `hosts` where `name` like  '" +hostname +"'"
# ִ��sql��䣬��ȡ�α����
cursor.execute(sql1)
# ����α������
id = cursor.fetchall()
# ��ȡ�ü�����ȡ��ֵ
hostid = value(id)

#��ȡitemid����
sql2="select  itemid from items  order by itemid desc LIMIT 0,1"
cursor.execute(sql2)
id = cursor.fetchall()
itemid1 = value(id)
itemid=itemid1+1

#����˿ڼ��
sql3="insert into `items` (`itemid`,`hostid`,`name`,`key_`,`delay`,`formula`,`interfaceid`)values("+str(itemid)+","+str(hostid)+",concat('port status',"+str(port)+"),concat('net.tcp.port[','"+str(hostname)+"',',','"+str(port)+"',']'),'30','1','27')"
#�½�triggeridģ��
sql4="insert into triggers(triggerid)(select triggerid+'1' from triggers  order by triggerid desc LIMIT 0,1)"
#������ʽ
sql5="insert into functions(functionid,itemid,triggerid,function,parameter) (select a.functionid +'1',b.itemid,c.triggerid,'last','0' from functions as a ,items as b,triggers as c where b.itemid in (select b1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as b1) and c.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and a.functionid in (select a1.functionid from (select functionid from functions order by functionid desc LIMIT 0,1) as a1))"
#���±���
sql6="update triggers a, functions b ,items as c set a.expression=concat('{',b.functionid, '}=0' ),a.priority= '5', a.description=concat('{HOST.NAME}', c.name ,'is not runnning') where a.triggerid =b.triggerid and a.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and c.itemid =b.itemid"
#�½�����graphsģ��
sql7="insert into graphs(graphid) (select graphid+'1' from graphs  order by graphid desc LIMIT 0,1)"
#���뱨������
sql8="insert into graphs_items(gitemid,graphid,itemid)(select a.gitemid +'1',b.graphid,c.itemid from graphs_items a,graphs b,items c where a.gitemid in  (select a1.gitemid from ( select gitemid from graphs_items order by gitemid desc LIMIT 0,1)as a1) and b.graphid in  (select b1.graphid from ( select graphid from graphs order by graphid desc LIMIT 0,1)as b1) and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1) )"
#���±���graphs����
sql9="update graphs_items a,graphs b,items c set b.name =c.name where b.graphid=a.graphid and a.itemid =c.itemid and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1)"


#ִ��sql���
cursor.execute(sql3)
cursor.execute(sql4)
cursor.execute(sql5)
cursor.execute(sql6)
cursor.execute(sql7)
cursor.execute(sql8)
cursor.execute(sql9)
db.commit()
# �����Ϣ
print "����ip: ", hostname	
print "��ض˿�: ", port	
print "192.168.105.207 hostid is :", hostid 
print "��ӵ�itemid is :",itemid

# �ر����ݿ�����
db.close()



