#coding: utf-8

import MySQLdb
import os

#������������ݺ���
def value( val ):
    a = val[0]
    b = a[0]
    return b	

	
	
#��oam���ݿ�����
db1 = MySQLdb.connect("10.1.134.60","root","@2015","oam",charset="utf8" )	
# ʹ��cursor()������ȡ�����α� 
cursor1 = db1.cursor() 
#sql��ѯ����ȡ���¼�ض˿�
sql11="select value from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1"
#ִ��sql��䣬��ȡ�α����
cursor1.execute(sql11)
#����α�����
port_value=cursor1.fetchall()
#��ȡ��ض˿�
port=value(port_value)

	
#��ȡ������ӵ�zabbbix��ض˿��߿�������������IP
sql12="select value from catalog_product_entity_varchar where entity_id in (select a1.entity_id from (select entity_id from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1)as a1) and attribute_id like '162'"
cursor1.execute(sql12)
hostname_value=cursor1.fetchall()
hostname=value(hostname_value)

#��ȡ������ӵ�zabbbix��ض˿ڲ�Ʒ����
sql13="select value from catalog_product_entity_varchar where entity_id in (select a1.entity_id from (select entity_id from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1)as a1) and attribute_id like '71'"
cursor1.execute(sql13)
name_value=cursor1.fetchall()
name=value(name_value)


# ��zabbix���ݿ�����
db2 = MySQLdb.connect("10.1.130.206","root","@2015","zabbix",charset="utf8" )
# ʹ��cursor()������ȡ�����α� 
cursor2 = db2.cursor() 
# SQL ��ѯ����ȡhostid
sql21="SELECT `hostid` from `hosts` where `name` like  '" +hostname +"'"
# ִ��sql��䣬��ȡ�α����
cursor2.execute(sql21)
# ����α������
id = cursor2.fetchall()
# ��ȡ�ü�����ȡ��ֵ
hostid = value(id)

#��ȡitemid����
sql22="select  itemid from items  order by itemid desc LIMIT 0,1"
cursor2.execute(sql22)
id = cursor2.fetchall()
itemid1 = value(id)
itemid=itemid1+1

#����˿ڼ��
sql23="insert into `items` (`itemid`,`hostid`,`name`,`key_`,`delay`,`formula`,`interfaceid`)values("+str(itemid)+","+str(hostid)+",concat('"+name+"port',"+str(port)+"),concat('net.tcp.port[','"+str(hostname)+"',',','"+str(port)+"',']'),'30','1','27')"
#�½�triggeridģ��
sql24="insert into triggers(triggerid)(select triggerid+'1' from triggers  order by triggerid desc LIMIT 0,1)"
#������ʽ
sql25="insert into functions(functionid,itemid,triggerid,function,parameter) (select a.functionid +'1',b.itemid,c.triggerid,'last','0' from functions as a ,items as b,triggers as c where b.itemid in (select b1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as b1) and c.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and a.functionid in (select a1.functionid from (select functionid from functions order by functionid desc LIMIT 0,1) as a1))"
#���±���
sql26="update triggers a, functions b ,items as c set a.expression=concat('{',b.functionid, '}=0' ),a.priority= '5', a.description=concat( c.name,'is not runnning') where a.triggerid =b.triggerid and a.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and c.itemid =b.itemid"
#�½�����graphsģ��
sql27="insert into graphs(graphid) (select graphid+'1' from graphs  order by graphid desc LIMIT 0,1)"
#���뱨������
sql28="insert into graphs_items(gitemid,graphid,itemid)(select a.gitemid +'1',b.graphid,c.itemid from graphs_items a,graphs b,items c where a.gitemid in  (select a1.gitemid from ( select gitemid from graphs_items order by gitemid desc LIMIT 0,1)as a1) and b.graphid in  (select b1.graphid from ( select graphid from graphs order by graphid desc LIMIT 0,1)as b1) and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1) )"
#���±���graphs����
sql29="update graphs_items a,graphs b,items c set b.name =c.name where b.graphid=a.graphid and a.itemid =c.itemid and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '"+str(hostname)+"') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1)"


#ִ��sql���
cursor2.execute(sql23)
cursor2.execute(sql24)
cursor2.execute(sql25)
cursor2.execute(sql26)
cursor2.execute(sql27)
cursor2.execute(sql28)
cursor2.execute(sql29)
db2.commit()
# �����Ϣ
print "����ip: ", hostname	
print "��ض˿�: ", port
print "��Ʒ����: ", name	
print "hostid is :", hostid 
print "��ӵ�itemid is :",itemid

# �ر����ݿ�����
db1.close()
db2.close()



