#!/usr/bin/python

----��ѯ����host��ip
SELECT host from hosts where host LIKE '10%' or host LIKE'192%'
----��ѯ���м�ض˿�
select a.key_ from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%'
----��ѯ���м�ض˿�itemid
select itemid from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%'


----��ѯ���м�ض˿�itemid�Ѽӵ�������itemid
select DISTINCT itemid from functions where itemid in (select itemid from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%')

----��ѯ���м�ض˿�itemid�Ѽӵ�ͼ���itemid
select DISTINCT itemid from graphs_items where itemid in (select itemid from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%')

----��ѯ���������Ͷ�Ӧ��ض˿�
select b.host,a.key_ from items a,hosts b where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%' and a.hostid=b.hostid

select b.host,a.key_ from items a,hosts b,functions c where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%' and a.hostid=b.hostid and a.itemid =c.itemid

----��ѯ ����ID
SELECT `hostid` from `hosts` where `host` like  '10.1.130.82'

----��ѯ�����
SELECT * from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207')

---����˿ڼ��
insert into items (itemid,hostid,name,key_,delay,formula,interfaceid) (select  itemid + '1','10126','port status7073','net.tcp.port[192.168.105.207,7073]','30','1','27' from items  order by itemid desc LIMIT 0,1)


----��ѯ������
SELECT * from  functions where itemid in (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207'))

SELECT * FROM `triggers` where triggerid in (SELECT triggerid from  functions where itemid in (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207')))
---�½�triggeridģ��
insert into triggers(triggerid)(select triggerid+'1' from triggers  order by triggerid desc LIMIT 0,1)

---������ʽ
insert into functions(functionid,itemid,triggerid,function,parameter) (select a.functionid +'1',b.itemid,c.triggerid,'last','0' from functions as a ,items as b,triggers as c where b.itemid in (select b1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `host` like  '192.168.105.207') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as b1) and c.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and a.functionid in (select a1.functionid from (select functionid from functions order by functionid desc LIMIT 0,1) as a1))
---���±���
update triggers a, functions b ,items as c set a.expression=concat('{',b.functionid, '}=0' ),a.priority= '5', a.description=concat('{HOST.NAME}', c.name ,'is not runnning') where a.triggerid =b.triggerid and a.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and c.itemid =b.itemid

--��ѯͼ��
select * from graphs a,graphs_items b where b.itemid in (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207')) and a.graphid=b.graphid

---�½�����graphsģ��
insert into graphs(graphid) (select graphid+'1' from graphs  order by graphid desc LIMIT 0,1)
---���뱨������
insert into graphs_items(gitemid,graphid,itemid)(select a.gitemid +'1',b.graphid,c.itemid from graphs_items a,graphs b,items c where a.gitemid in  (select a1.gitemid from ( select gitemid from graphs_items order by gitemid desc LIMIT 0,1)as a1) and b.graphid in  (select b1.graphid from ( select graphid from graphs order by graphid desc LIMIT 0,1)as b1) and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `host` like  '192.168.105.207') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1) )
----���±���graphs����
update graphs_items a,graphs b,items c set b.name =c.name where b.graphid=a.graphid and a.itemid =c.itemid and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1)








----ɾ���˿ڼ�������ȫ��ɾ���˿ڼ��
DELETE a.* from items a,hosts b where b.host like '192.168.105.207' and b.hostid=a.hostid and (key_ like 'net.tcp.port[192.168.105.207,7074]' or key_ like 'net.tcp.port[,7074]' or key_ like 'net.tcp.listen[7074]')







----_product_info  ��Ʒ��Ϣ   _ip_list ������IP��Ϣ  catalog_product_entity_varchar ��Ʒ¼������  catalog_eav_attribute ¼�����������Ա� 
----eav_attribute ��Ʒ�������Ʊ�   core_storeȨ��  customer_entity �˺�  eav_attribute_option_value ���������ݱ�  catalog_product_index_eav  ����Ʒ״̬������������ ״̬�ȣ�catalog_product_index_eav_idx


----��ѯ��Ʒ����δ�¼�
SELECT * from _product_info where pstatus not like '���¼�'
----��ѯ����������Ʒ
select ip from _ip_list where type like '��������'

---����ip��
CREATE TABLE `ip` (
  `ip` varchar(20) NOT NULL DEFAULT '' ,
   PRIMARY KEY (`ip`)
) ENGINE=MyISAM AUTO_INCREMENT=1070 DEFAULT CHARSET=utf8;
---��ѯ��������¼��IP
SELECT DISTINCT `value` as ip   from catalog_product_entity_varchar where attribute_id like '162'

create table ip SELECT DISTINCT `value` as ip   from catalog_product_entity_varchar where attribute_id like '162'
---��ѯ�����߿���������������ip
select ip from ip where ip like '10.228%'
--��ѯ�߿�����������Ʒ����
SELECT DISTINCT `value` as ��Ʒ����   from catalog_product_entity_varchar where attribute_id like '71'
---��ѯ���ز�Ʒ���ƺͶ�Ӧ������ip
SELECT DISTINCT a.value as ��Ʒ���� , b.value as ip from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162'
---��ѯ�߿ڻ������ز�Ʒ���ƺͶ�Ӧ������ip
SELECT DISTINCT a.value as ��Ʒ���� , b.value as ip from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from ip where ip like '10.228%')
---��ѯ�߿ڻ������ز�Ʒ���ƺͶ�Ӧ������ip����ά������ ����Ʒ״̬
SELECT DISTINCT a.value as ��Ʒ���� , b.value as ip,d.value as ��ά�����˼�״̬ from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id 

SELECT DISTINCT a.value as ��Ʒ���� , b.value as ip,d.value as ��ά�����˼�״̬ from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav_idx as c ,eav_attribute_option_value as d where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id 

SELECT * from catalog_product_index_eav_idx where entity_id not in (SELECT entity_id from catalog_product_index_eav)

SELECT * from catalog_product_index_eav_idx where entity_id not in (SELECT DISTINCT entity_id from catalog_product_entity_varchar)

-----��ѯ�߿ڻ�������δ�¼ܲ�Ʒ���ƺͶ�Ӧ������ip����Ʒ״̬ 
SELECT DISTINCT a.value as ��Ʒ���� , b.value as ip,d.value as ״̬ from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d  where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id and c.value  in ('55','54','53')  ORDER BY ��Ʒ����
-----��ѯ�߿ڻ�������δ�¼ܲ�Ʒ���ƺͶ�Ӧ������ip����ά������
SELECT DISTINCT a.value as ��Ʒ���� , b.value as ip,d.value as ��ά������ from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d  where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id and c.value  not in ('55','54','53') ORDER BY ��Ʒ����

----��ѯ������ӵ�zabbix��ض˿�����,��ȡֵ
select value from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1

---��ѯ������ӵ�zabbbix��ض˿��߿�������������IP
select value from catalog_product_entity_varchar where entity_id in (select a1.entity_id from (select entity_id from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1)as a1) and attribute_id like '162'
----��ѯ������ӵ�zabbbix��ض˿ڲ�Ʒ����
select value from catalog_product_entity_varchar where entity_id in (select a1.entity_id from (select entity_id from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1)as a1) and attribute_id like '71'

----������ͼ
CREATE VIEW `v_zabbix_zabbixport`AS select value,entity_id from catalog_product_entity_varchar where attribute_id = '186';
----������ͼ��ʱ��
CREATE algorithm=temptable VIEW `v_zabbix_zabbixport`AS select value,entity_id from catalog_product_entity_varchar where attribute_id = '186';
-----������ͼ
ALTER VIEW `v_zabbix_zabbixport`AS select value,entity_id from catalog_product_entity_varchar where attribute_id = '186'
----ɾ����ͼ
drop VIEW `v_zabbix_zabbixport`

----�����˿���ͼ
CREATE  VIEW `v_zabbix_zabbixport`AS select entity_id,value as port from catalog_product_entity_varchar where attribute_id = '186' and value not is null;
----�����߿�������������IP��ͼ
CREATE  VIEW `v_zabbix_zabbixhostname`AS select entity_id,value as ip from catalog_product_entity_varchar where entity_id in (select entity_id from v_zabbix_zabbixport) and attribute_id like '162';
----����zabbbix��ض˿ڲ�Ʒ������ͼ
CREATE  VIEW `v_zabbix_zabbixname`AS select entity_id,value as name from catalog_product_entity_varchar where entity_id in (select entity_id from v_zabbix_zabbixport) and attribute_id like '71';
----������Ʒ����ʱ����ͼ
CREATE  VIEW `v_zabbix_zabbixupdated`AS select entity_id,updated_at as updated from catalog_product_entity where entity_id in (select entity_id from v_zabbix_zabbixport);
----����zabbix�Զ���ӵ�������ͼ
CREATE  VIEW `v_zabbix_zabbixinfo` As  select a.entity_id,a.port,b.ip,c.name,d.updated from v_zabbix_zabbixport as a,v_zabbix_zabbixhostname as b,v_zabbix_zabbixname as c,v_zabbix_zabbixupdated d where a.entity_id=b.entity_id and b.entity_id=c.entity_id and c.entity_id=d.entity_id;

----��ȡ��ά����������
SELECT a.VALUE from eav_attribute_option_value a,eav_attribute_option b where b.attribute_id like '135' and b.option_id=a.option_id and a.store_id like '1'

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `v_customer_renyuan` AS select `customer_entity_varchar`.`entity_id` AS `entity_id`,group_concat(`customer_entity_varchar`.`value` separator '') AS `username` from `customer_entity_varchar` where (`customer_entity_varchar`.`attribute_id` in (5,7)) group by `customer_entity_varchar`.`entity_id`;


---��ѯ��Ʒ���¼ܣ�����ʾ�Ĳ�Ʒ��Ϣ
SELECT DISTINCT a.entity_id,b.`value` as ���� ,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as ״̬   from catalog_product_entity_int a,catalog_product_entity_varchar b where a.attribute_id like '96'  and a.entity_id=b.entity_id  and b.attribute_id like '71' ORDER BY ״̬

SELECT DISTINCT a.entity_id,b.`value` as ���� ,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as ״̬   from catalog_product_entity_int a,catalog_product_entity_varchar b where a.attribute_id like '96' and a.`value` like '2' and a.entity_id=b.entity_id  and b.attribute_id like '71'

SELECT DISTINCT a.entity_id,b.`value` as ����,c.value as ��ά������,(case WHEN a.`value`!='2' then 'disable' else 'enable' end) as ״̬   from catalog_product_entity_int a,catalog_product_entity_varchar b ,eav_attribute_option_value as c where a.entity_id in (select aa.entity_id from (select entity_id from catalog_product_entity_int where attribute_id like '96' and `value` like '2') as aa) and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.attribute_id like '135' and a.value=c.option_id

---��ѯδ�¼ܵĲ�Ʒ״̬����Щδ����
SELECT DISTINCT a.value as ��Ʒ���� , b.value as ip,d.value as ��ά������ from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d  where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id and c.value  in ('55','54','53') ORDER BY ��Ʒ����

SELECT DISTINCT a.value as ��Ʒ���� , b.value as ip,d.value as ��ά������ from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d  where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id and c.value  like '55' ORDER BY ��Ʒ����
---��ѯδ�¼ܲ�Ʒ��Ϣ
SELECT DISTINCT a.entity_id,b.`value` as ����,c.value as ��ά������,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as ״̬   from catalog_product_index_eav a,catalog_product_entity_varchar b ,eav_attribute_option_value as c where a.attribute_id like '135' and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.value=c.option_id

----��ѯδ�¼ܲ�Ʒ��Ϣ������������
SELECT DISTINCT a.entity_id,b.`value` as ����,c.value as ��ά������,d.email,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as ״̬   from catalog_product_index_eav a,catalog_product_entity_varchar b ,eav_attribute_option_value as c, v_customer_info d where a.attribute_id like '135' and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.value=c.option_id and c.value=d.username

---����δ�¼ܲ�Ʒ��Ϣ��������������ͼ
create view `v_zabbix_userinfo` As SELECT DISTINCT a.entity_id,b.`value` as name,c.value as own,d.email,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as status from catalog_product_index_eav a,catalog_product_entity_varchar b ,eav_attribute_option_value as c, v_customer_info d where a.attribute_id like '135' and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.value=c.option_id and c.value in ('����','�¿���','������','������','��С֥','��«','���') and c.value=d.username ORDER BY own desc;

----����zabbbix��ض˿��¼ܲ�Ʒid��ͼ
CREATE  VIEW `v_zabbix_productdown`AS select entity_id,(case WHEN `value`='2' then 'disable' else 'enable' end) as status from catalog_product_entity_int where attribute_id like '96' and `value` like '2';

----�����¼ܲ�Ʒ��Ϣ��ͼ
create view `v_zabbix_downinfo` As SELECT DISTINCT a.entity_id,b.`value` as name,c.value as own,d.email,(case WHEN a.`value`!='2' then 'disable' else 'enable' end) as status   from catalog_product_entity_int a,catalog_product_entity_varchar b ,eav_attribute_option_value as c, v_customer_info d where a.entity_id in (select entity_id from v_zabbix_productdown) and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.attribute_id like '135' and a.value=c.option_id  and  c.value=d.username ORDER BY own desc;

----��ȡ��Ʒ��ά����������
SELECT email from v_zabbix_userinfo where entity_id in (SELECT entity_id from v_zabbix_zabbixinfo where ip like '10.228.1.10' and port like '8078')


----��ѯ��ʾ��Ʒ
SELECT * from catalog_product_entity where attribute_set_id like '9'
SELECT entity_id from catalog_product_entity where attribute_set_id like '9'
----��ѯƽ̨�鸺���δ�¼ܲ�Ʒ
select  a.entity_id,a.����,a.��ά������  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')


-----����������ʾ��ַ���������������ַ��Ϣ���ϲ���

select  a.entity_id,a.����,a.��ά������,b.value as ��ɽ��ʾ��ַ,c.value as �߿���ʾ��ַ,d.value as �������ʵ�ַ ,e.value as ����������ַ ,f.value as ��ʾ�˺ż����� ,g.value as Ĭ�Ϻ�̨����Ա�˺� ,h.value as web������IP ,i.value as zabbix��ض˿� ,j.value as ���ݿ������IP ,k.value as ���ݿ��� ,l.value as ���ݿ��û� ,m.value as ���ݿ����� ,n.value as ���ݿ�˿� ,p.value as ��Ʒϵͳ�ܹ�,r.value as ���ݿ����� from v_zabbix_userinfo a,catalog_product_entity_varchar b ,catalog_product_entity_varchar c,catalog_product_entity_varchar d ,catalog_product_entity_varchar e ,catalog_product_entity_varchar f ,catalog_product_entity_varchar g ,catalog_product_entity_varchar h ,catalog_product_entity_varchar i ,catalog_product_entity_varchar j ,catalog_product_entity_varchar k ,catalog_product_entity_varchar l ,catalog_product_entity_varchar m ,catalog_product_entity_varchar n ,catalog_product_entity_int o ,eav_attribute_option_value p ,catalog_product_entity_int q ,eav_attribute_option_value r where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=b.entity_id and b.attribute_id ='151' and a.entity_id=c.entity_id and c.attribute_id ='152' and a.entity_id=d.entity_id and d.attribute_id ='153'  and a.entity_id=e.entity_id and e.attribute_id ='154'  and a.entity_id=f.entity_id and f.attribute_id ='155' and f.attribute_id ='155' and a.entity_id=g.entity_id and g.attribute_id ='184' and a.entity_id=h.entity_id and h.attribute_id ='162'  and a.entity_id=j.entity_id and j.attribute_id ='161' and a.entity_id=k.entity_id and k.attribute_id ='147' and a.entity_id=l.entity_id and l.attribute_id ='175' and a.entity_id=m.entity_id and m.attribute_id ='149' and a.entity_id=n.entity_id and n.attribute_id ='148' and a.entity_id=i.entity_id and i.attribute_id ='186' and a.entity_id=o.entity_id and o.attribute_id='144' and o.value=p.option_id and a.entity_id=q.entity_id and q.attribute_id='146' and q.value=r.option_id 

-----����������ʾ��ַ��Ϣ
select DISTINCT a.entity_id,a.����,a.��ά������,b.value as ��ɽ��ʾ��ַ,c.value as �߿���ʾ��ַ ,d.value as �������ʵ�ַ ,e.value as ����������ַ ,f.value as ��ʾ�˺ż����� ,g.value as Ĭ�Ϻ�̨����Ա�˺�  from v_zabbix_userinfo a,catalog_product_entity_varchar b ,catalog_product_entity_varchar c ,catalog_product_entity_varchar d ,catalog_product_entity_varchar e ,catalog_product_entity_varchar f ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=b.entity_id and b.attribute_id ='151' and a.entity_id=c.entity_id and c.attribute_id ='152' and a.entity_id=d.entity_id and d.attribute_id ='153' and a.entity_id=e.entity_id and e.attribute_id ='154' and a.entity_id=f.entity_id and f.attribute_id ='155' and a.entity_id=g.entity_id and g.attribute_id ='184' 

-----�������������ַ��Ϣ

select DISTINCT a.entity_id,a.����,a.��ά������,h.value as web������IP ,i.value as zabbix��ض˿� ,j.value as ���ݿ������IP ,k.value as ���ݿ��� ,l.value as ���ݿ��û� ,m.value as ���ݿ�����,n.value as ���ݿ�˿� ,p.value as ��Ʒϵͳ�ܹ�,r.value as ���ݿ����� from v_zabbix_userinfo a,catalog_product_entity_varchar h ,catalog_product_entity_varchar i ,catalog_product_entity_varchar j ,catalog_product_entity_varchar k ,catalog_product_entity_varchar l ,catalog_product_entity_varchar m ,catalog_product_entity_varchar n ,catalog_product_entity_int o ,eav_attribute_option_value p ,catalog_product_entity_int q ,eav_attribute_option_value r where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=h.entity_id and h.attribute_id ='162'  and a.entity_id=j.entity_id and j.attribute_id ='161' and a.entity_id=k.entity_id and k.attribute_id ='147' and a.entity_id=l.entity_id and l.attribute_id ='175' and a.entity_id=m.entity_id and m.attribute_id ='149' and a.entity_id=n.entity_id and n.attribute_id ='148' and a.entity_id=i.entity_id and i.attribute_id ='186' and a.entity_id=o.entity_id and o.attribute_id='144' and o.value=p.option_id and p.store_id ='0' and a.entity_id=q.entity_id and q.attribute_id='146' and q.value=r.option_id and r.store_id ='0'


---��ѯ�Ѹ�������Ĭ�Ϻ�̨����Ա�˺�
select  a.entity_id,a.����,a.��ά������,g.value as Ĭ�Ϻ�̨����Ա�˺� from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='184' 

---��ѯ�Ѹ�������zabbix��ض˿�(�ϼܲ�Ʒ)
select  a.entity_id,a.����,a.��ά������,g.value as zabbix��ض˿� from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='186'

select  a.entity_id,a.����,a.��ά������,g.value as zabbix��ض˿� from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9' and entity_id not in (select entity_id from v_zabbix_productdown)) and a.entity_id=g.entity_id and g.attribute_id ='186' 
----��ѯ�Ѹ����������ݿ�����
select a.entity_id,a.����,a.��ά������,p.value as ���ݿ����� from v_zabbix_userinfo a ,catalog_product_entity_int o ,eav_attribute_option_value p where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=o.entity_id and o.attribute_id='146' and o.value=p.option_id 
and p.store_id ='0'

----��ѯ�Ѹ������Բ�Ʒϵͳ�ܹ�
select a.entity_id,a.����,a.��ά������,p.value as ��Ʒϵͳ�ܹ� from v_zabbix_userinfo a ,catalog_product_entity_int o ,eav_attribute_option_value p where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=o.entity_id and o.attribute_id='144' and o.value=p.option_id 
and p.store_id ='0'


---������ʱ��
create temporary table aa select  a.entity_id from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='184'

create temporary table bb select  a.entity_id,a.����,a.��ά������  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')

---��ȡδ��������Ĭ�Ϻ�̨����Ա�˺Ų�Ʒ��Ϣ
SELECT * from (select  a.entity_id,a.����,a.��ά������  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')) as bb where entity_id not in (SELECT entity_id from (select  a.entity_id from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='184') as aa )

----��ȡδ��������zabbix��ض˿ڲ�Ʒ��Ϣ
SELECT * from (select  a.entity_id,a.����,a.��ά������  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')) as bb where entity_id not in (SELECT entity_id from (select  a.entity_id from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='186') as aa ) 

SELECT * from (select  a.entity_id,a.����,a.��ά������  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9'  and entity_id not in (select entity_id from v_zabbix_productdown))) as bb where entity_id not in (SELECT entity_id from (select  a.entity_id from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9' and entity_id not in (select entity_id from v_zabbix_productdown)) and a.entity_id=g.entity_id and g.attribute_id ='186' ) as aa ) 

----��ȡδ�����������ݿ����Ͳ�Ʒ��Ϣ
SELECT * from (select  a.entity_id,a.����,a.��ά������  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')) as bb where entity_id not in (SELECT entity_id from (select a.entity_id,a.����,a.��ά������,p.value as ���ݿ����� from v_zabbix_userinfo a ,catalog_product_entity_int o ,eav_attribute_option_value p where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=o.entity_id and o.attribute_id='146' and o.value=p.option_id and p.store_id ='0') as aa )
----��ѯ��˿�����
select name from v_zabbix_zabbixinfo where ip like '10.228.3.73' and (port like '%,8091' or port like '%,8091,%' or port like '8091,%')
---��ѯ��Ʒ������ͬ��Ʒ
select * from v_zabbix_zabbixinfo where name in (select name from v_zabbix_zabbixinfo group by name having COUNT(*)>1)
(SELECT `value` as name from catalog_product_entity_varchar where attribute_id='71') as aa
select * from (SELECT `value` as name from catalog_product_entity_varchar where attribute_id='71') as aa where name in (select name from (SELECT `value` as name from catalog_product_entity_varchar where attribute_id='71') as aa group by name having COUNT(*)>1)
----��ѯ���߲�Ʒ����
select name from v_zabbix_zabbixinfo where entity_id not in(SELECT entity_id from v_zabbix_productdown) ORDER BY updated DESC


