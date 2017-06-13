#!/usr/bin/python

----查询所有host的ip
SELECT host from hosts where host LIKE '10%' or host LIKE'192%'
----查询所有监控端口
select a.key_ from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%'
----查询所有监控端口itemid
select itemid from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%'


----查询所有监控端口itemid已加到报警的itemid
select DISTINCT itemid from functions where itemid in (select itemid from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%')

----查询所有监控端口itemid已加到图表的itemid
select DISTINCT itemid from graphs_items where itemid in (select itemid from items a where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%')

----查询所有主机和对应监控端口
select b.host,a.key_ from items a,hosts b where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%' and a.hostid=b.hostid

select b.host,a.key_ from items a,hosts b,functions c where a.hostid  in (SELECT hostid from hosts where host LIKE '10%' or host LIKE'192%') and a.key_ like 'net.tcp%' and a.hostid=b.hostid and a.itemid =c.itemid

----查询 主机ID
SELECT `hostid` from `hosts` where `host` like  '10.1.130.82'

----查询监控项
SELECT * from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207')

---插入端口监控
insert into items (itemid,hostid,name,key_,delay,formula,interfaceid) (select  itemid + '1','10126','port status7073','net.tcp.port[192.168.105.207,7073]','30','1','27' from items  order by itemid desc LIMIT 0,1)


----查询报警项
SELECT * from  functions where itemid in (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207'))

SELECT * FROM `triggers` where triggerid in (SELECT triggerid from  functions where itemid in (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207')))
---新建triggerid模板
insert into triggers(triggerid)(select triggerid+'1' from triggers  order by triggerid desc LIMIT 0,1)

---插入表达式
insert into functions(functionid,itemid,triggerid,function,parameter) (select a.functionid +'1',b.itemid,c.triggerid,'last','0' from functions as a ,items as b,triggers as c where b.itemid in (select b1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `host` like  '192.168.105.207') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as b1) and c.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and a.functionid in (select a1.functionid from (select functionid from functions order by functionid desc LIMIT 0,1) as a1))
---更新报警
update triggers a, functions b ,items as c set a.expression=concat('{',b.functionid, '}=0' ),a.priority= '5', a.description=concat('{HOST.NAME}', c.name ,'is not runnning') where a.triggerid =b.triggerid and a.triggerid in (select c1.triggerid from ( select triggerid from triggers order by triggerid desc LIMIT 0,1)as c1) and c.itemid =b.itemid

--查询图表
select * from graphs a,graphs_items b where b.itemid in (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207')) and a.graphid=b.graphid

---新建报表graphs模板
insert into graphs(graphid) (select graphid+'1' from graphs  order by graphid desc LIMIT 0,1)
---插入报表数据
insert into graphs_items(gitemid,graphid,itemid)(select a.gitemid +'1',b.graphid,c.itemid from graphs_items a,graphs b,items c where a.gitemid in  (select a1.gitemid from ( select gitemid from graphs_items order by gitemid desc LIMIT 0,1)as a1) and b.graphid in  (select b1.graphid from ( select graphid from graphs order by graphid desc LIMIT 0,1)as b1) and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `host` like  '192.168.105.207') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1) )
----更新报表graphs名称
update graphs_items a,graphs b,items c set b.name =c.name where b.graphid=a.graphid and a.itemid =c.itemid and c.itemid in (select c1.itemid from (SELECT itemid from items where hostid in ( SELECT `hostid` from `hosts` where `name` like  '192.168.105.207') and key_ like 'net.tcp.port%'order by itemid desc LIMIT 0,1) as c1)








----删除端口监控项，等于全部删除端口监控
DELETE a.* from items a,hosts b where b.host like '192.168.105.207' and b.hostid=a.hostid and (key_ like 'net.tcp.port[192.168.105.207,7074]' or key_ like 'net.tcp.port[,7074]' or key_ like 'net.tcp.listen[7074]')







----_product_info  产品信息   _ip_list 服务器IP信息  catalog_product_entity_varchar 产品录入数据  catalog_eav_attribute 录入数据项属性表 
----eav_attribute 产品属性名称表   core_store权限  customer_entity 账号  eav_attribute_option_value 下拉框数据表  catalog_product_index_eav  各产品状态表（包括责任人 状态等）catalog_product_index_eav_idx


----查询产品名称未下架
SELECT * from _product_info where pstatus not like '已下架'
----查询生产环境产品
select ip from _ip_list where type like '生产环境'

---创建ip表
CREATE TABLE `ip` (
  `ip` varchar(20) NOT NULL DEFAULT '' ,
   PRIMARY KEY (`ip`)
) ENGINE=MyISAM AUTO_INCREMENT=1070 DEFAULT CHARSET=utf8;
---查询生产环境录入IP
SELECT DISTINCT `value` as ip   from catalog_product_entity_varchar where attribute_id like '162'

create table ip SELECT DISTINCT `value` as ip   from catalog_product_entity_varchar where attribute_id like '162'
---查询现有蛇口生产环境服务器ip
select ip from ip where ip like '10.228%'
--查询蛇口生产环境产品名称
SELECT DISTINCT `value` as 产品名称   from catalog_product_entity_varchar where attribute_id like '71'
---查询需监控产品名称和对应服务器ip
SELECT DISTINCT a.value as 产品名称 , b.value as ip from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162'
---查询蛇口环境需监控产品名称和对应服务器ip
SELECT DISTINCT a.value as 产品名称 , b.value as ip from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from ip where ip like '10.228%')
---查询蛇口环境需监控产品名称和对应服务器ip，运维负责人 ，产品状态
SELECT DISTINCT a.value as 产品名称 , b.value as ip,d.value as 运维负责人及状态 from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id 

SELECT DISTINCT a.value as 产品名称 , b.value as ip,d.value as 运维负责人及状态 from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav_idx as c ,eav_attribute_option_value as d where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id 

SELECT * from catalog_product_index_eav_idx where entity_id not in (SELECT entity_id from catalog_product_index_eav)

SELECT * from catalog_product_index_eav_idx where entity_id not in (SELECT DISTINCT entity_id from catalog_product_entity_varchar)

-----查询蛇口环境需监控未下架产品名称和对应服务器ip，产品状态 
SELECT DISTINCT a.value as 产品名称 , b.value as ip,d.value as 状态 from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d  where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id and c.value  in ('55','54','53')  ORDER BY 产品名称
-----查询蛇口环境需监控未下架产品名称和对应服务器ip，运维负责人
SELECT DISTINCT a.value as 产品名称 , b.value as ip,d.value as 运维负责人 from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d  where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id and c.value  not in ('55','54','53') ORDER BY 产品名称

----查询最新添加的zabbix监控端口属性,获取值
select value from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1

---查询最新添加的zabbbix监控端口蛇口生产环境主机IP
select value from catalog_product_entity_varchar where entity_id in (select a1.entity_id from (select entity_id from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1)as a1) and attribute_id like '162'
----查询最新添加的zabbbix监控端口产品名称
select value from catalog_product_entity_varchar where entity_id in (select a1.entity_id from (select entity_id from catalog_product_entity_varchar where attribute_id = '186' order by value_id desc LIMIT 0,1)as a1) and attribute_id like '71'

----创建视图
CREATE VIEW `v_zabbix_zabbixport`AS select value,entity_id from catalog_product_entity_varchar where attribute_id = '186';
----创建视图临时表
CREATE algorithm=temptable VIEW `v_zabbix_zabbixport`AS select value,entity_id from catalog_product_entity_varchar where attribute_id = '186';
-----更新视图
ALTER VIEW `v_zabbix_zabbixport`AS select value,entity_id from catalog_product_entity_varchar where attribute_id = '186'
----删除视图
drop VIEW `v_zabbix_zabbixport`

----创建端口视图
CREATE  VIEW `v_zabbix_zabbixport`AS select entity_id,value as port from catalog_product_entity_varchar where attribute_id = '186' and value not is null;
----创建蛇口生产环境主机IP视图
CREATE  VIEW `v_zabbix_zabbixhostname`AS select entity_id,value as ip from catalog_product_entity_varchar where entity_id in (select entity_id from v_zabbix_zabbixport) and attribute_id like '162';
----创建zabbbix监控端口产品名称视图
CREATE  VIEW `v_zabbix_zabbixname`AS select entity_id,value as name from catalog_product_entity_varchar where entity_id in (select entity_id from v_zabbix_zabbixport) and attribute_id like '71';
----创建产品更新时间视图
CREATE  VIEW `v_zabbix_zabbixupdated`AS select entity_id,updated_at as updated from catalog_product_entity where entity_id in (select entity_id from v_zabbix_zabbixport);
----创建zabbix自动添加的数据视图
CREATE  VIEW `v_zabbix_zabbixinfo` As  select a.entity_id,a.port,b.ip,c.name,d.updated from v_zabbix_zabbixport as a,v_zabbix_zabbixhostname as b,v_zabbix_zabbixname as c,v_zabbix_zabbixupdated d where a.entity_id=b.entity_id and b.entity_id=c.entity_id and c.entity_id=d.entity_id;

----获取运维负责人数据
SELECT a.VALUE from eav_attribute_option_value a,eav_attribute_option b where b.attribute_id like '135' and b.option_id=a.option_id and a.store_id like '1'

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `v_customer_renyuan` AS select `customer_entity_varchar`.`entity_id` AS `entity_id`,group_concat(`customer_entity_varchar`.`value` separator '') AS `username` from `customer_entity_varchar` where (`customer_entity_varchar`.`attribute_id` in (5,7)) group by `customer_entity_varchar`.`entity_id`;


---查询产品已下架，不显示的产品信息
SELECT DISTINCT a.entity_id,b.`value` as 名称 ,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as 状态   from catalog_product_entity_int a,catalog_product_entity_varchar b where a.attribute_id like '96'  and a.entity_id=b.entity_id  and b.attribute_id like '71' ORDER BY 状态

SELECT DISTINCT a.entity_id,b.`value` as 名称 ,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as 状态   from catalog_product_entity_int a,catalog_product_entity_varchar b where a.attribute_id like '96' and a.`value` like '2' and a.entity_id=b.entity_id  and b.attribute_id like '71'

SELECT DISTINCT a.entity_id,b.`value` as 名称,c.value as 运维负责人,(case WHEN a.`value`!='2' then 'disable' else 'enable' end) as 状态   from catalog_product_entity_int a,catalog_product_entity_varchar b ,eav_attribute_option_value as c where a.entity_id in (select aa.entity_id from (select entity_id from catalog_product_entity_int where attribute_id like '96' and `value` like '2') as aa) and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.attribute_id like '135' and a.value=c.option_id

---查询未下架的产品状态，哪些未更改
SELECT DISTINCT a.value as 产品名称 , b.value as ip,d.value as 运维负责人 from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d  where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id and c.value  in ('55','54','53') ORDER BY 产品名称

SELECT DISTINCT a.value as 产品名称 , b.value as ip,d.value as 运维负责人 from catalog_product_entity_varchar  as a,catalog_product_entity_varchar  as b, catalog_product_index_eav as c ,eav_attribute_option_value as d  where a.entity_id =b.entity_id and a.attribute_id like '71' and  b.attribute_id like '162' and b.value in (select ip from (SELECT DISTINCT `value` as ip from catalog_product_entity_varchar where attribute_id like '162') as ip where ip like '10.228%') and b.entity_id =c.entity_id and c.value =d.option_id and c.value  like '55' ORDER BY 产品名称
---查询未下架产品信息
SELECT DISTINCT a.entity_id,b.`value` as 名称,c.value as 运维负责人,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as 状态   from catalog_product_index_eav a,catalog_product_entity_varchar b ,eav_attribute_option_value as c where a.attribute_id like '135' and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.value=c.option_id

----查询未下架产品信息，责任人邮箱
SELECT DISTINCT a.entity_id,b.`value` as 名称,c.value as 运维负责人,d.email,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as 状态   from catalog_product_index_eav a,catalog_product_entity_varchar b ,eav_attribute_option_value as c, v_customer_info d where a.attribute_id like '135' and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.value=c.option_id and c.value=d.username

---创建未下架产品信息，责任人邮箱视图
create view `v_zabbix_userinfo` As SELECT DISTINCT a.entity_id,b.`value` as name,c.value as own,d.email,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as status from catalog_product_index_eav a,catalog_product_entity_varchar b ,eav_attribute_option_value as c, v_customer_info d where a.attribute_id like '135' and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.value=c.option_id and c.value in ('吴鹏','陈俊聪','刘永华','江婉怡','龚小芝','柳芦','李军') and c.value=d.username ORDER BY own desc;

----创建zabbbix监控端口下架产品id视图
CREATE  VIEW `v_zabbix_productdown`AS select entity_id,(case WHEN `value`='2' then 'disable' else 'enable' end) as status from catalog_product_entity_int where attribute_id like '96' and `value` like '2';

----创建下架产品信息视图
create view `v_zabbix_downinfo` As SELECT DISTINCT a.entity_id,b.`value` as name,c.value as own,d.email,(case WHEN a.`value`!='2' then 'disable' else 'enable' end) as status   from catalog_product_entity_int a,catalog_product_entity_varchar b ,eav_attribute_option_value as c, v_customer_info d where a.entity_id in (select entity_id from v_zabbix_productdown) and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.attribute_id like '135' and a.value=c.option_id  and  c.value=d.username ORDER BY own desc;

----获取产品运维责任人邮箱
SELECT email from v_zabbix_userinfo where entity_id in (SELECT entity_id from v_zabbix_zabbixinfo where ip like '10.228.1.10' and port like '8078')


----查询演示产品
SELECT * from catalog_product_entity where attribute_set_id like '9'
SELECT entity_id from catalog_product_entity where attribute_set_id like '9'
----查询平台组负责的未下架产品
select  a.entity_id,a.名称,a.运维负责人  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')


-----生产环境演示地址和生产环境部署地址信息（合并）

select  a.entity_id,a.名称,a.运维负责人,b.value as 南山演示地址,c.value as 蛇口演示地址,d.value as 公网访问地址 ,e.value as 域名解析地址 ,f.value as 演示账号及密码 ,g.value as 默认后台管理员账号 ,h.value as web服务器IP ,i.value as zabbix监控端口 ,j.value as 数据库服务器IP ,k.value as 数据库名 ,l.value as 数据库用户 ,m.value as 数据库密码 ,n.value as 数据库端口 ,p.value as 产品系统架构,r.value as 数据库类型 from v_zabbix_userinfo a,catalog_product_entity_varchar b ,catalog_product_entity_varchar c,catalog_product_entity_varchar d ,catalog_product_entity_varchar e ,catalog_product_entity_varchar f ,catalog_product_entity_varchar g ,catalog_product_entity_varchar h ,catalog_product_entity_varchar i ,catalog_product_entity_varchar j ,catalog_product_entity_varchar k ,catalog_product_entity_varchar l ,catalog_product_entity_varchar m ,catalog_product_entity_varchar n ,catalog_product_entity_int o ,eav_attribute_option_value p ,catalog_product_entity_int q ,eav_attribute_option_value r where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=b.entity_id and b.attribute_id ='151' and a.entity_id=c.entity_id and c.attribute_id ='152' and a.entity_id=d.entity_id and d.attribute_id ='153'  and a.entity_id=e.entity_id and e.attribute_id ='154'  and a.entity_id=f.entity_id and f.attribute_id ='155' and f.attribute_id ='155' and a.entity_id=g.entity_id and g.attribute_id ='184' and a.entity_id=h.entity_id and h.attribute_id ='162'  and a.entity_id=j.entity_id and j.attribute_id ='161' and a.entity_id=k.entity_id and k.attribute_id ='147' and a.entity_id=l.entity_id and l.attribute_id ='175' and a.entity_id=m.entity_id and m.attribute_id ='149' and a.entity_id=n.entity_id and n.attribute_id ='148' and a.entity_id=i.entity_id and i.attribute_id ='186' and a.entity_id=o.entity_id and o.attribute_id='144' and o.value=p.option_id and a.entity_id=q.entity_id and q.attribute_id='146' and q.value=r.option_id 

-----生产环境演示地址信息
select DISTINCT a.entity_id,a.名称,a.运维负责人,b.value as 南山演示地址,c.value as 蛇口演示地址 ,d.value as 公网访问地址 ,e.value as 域名解析地址 ,f.value as 演示账号及密码 ,g.value as 默认后台管理员账号  from v_zabbix_userinfo a,catalog_product_entity_varchar b ,catalog_product_entity_varchar c ,catalog_product_entity_varchar d ,catalog_product_entity_varchar e ,catalog_product_entity_varchar f ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=b.entity_id and b.attribute_id ='151' and a.entity_id=c.entity_id and c.attribute_id ='152' and a.entity_id=d.entity_id and d.attribute_id ='153' and a.entity_id=e.entity_id and e.attribute_id ='154' and a.entity_id=f.entity_id and f.attribute_id ='155' and a.entity_id=g.entity_id and g.attribute_id ='184' 

-----生产环境部署地址信息

select DISTINCT a.entity_id,a.名称,a.运维负责人,h.value as web服务器IP ,i.value as zabbix监控端口 ,j.value as 数据库服务器IP ,k.value as 数据库名 ,l.value as 数据库用户 ,m.value as 数据库密码,n.value as 数据库端口 ,p.value as 产品系统架构,r.value as 数据库类型 from v_zabbix_userinfo a,catalog_product_entity_varchar h ,catalog_product_entity_varchar i ,catalog_product_entity_varchar j ,catalog_product_entity_varchar k ,catalog_product_entity_varchar l ,catalog_product_entity_varchar m ,catalog_product_entity_varchar n ,catalog_product_entity_int o ,eav_attribute_option_value p ,catalog_product_entity_int q ,eav_attribute_option_value r where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=h.entity_id and h.attribute_id ='162'  and a.entity_id=j.entity_id and j.attribute_id ='161' and a.entity_id=k.entity_id and k.attribute_id ='147' and a.entity_id=l.entity_id and l.attribute_id ='175' and a.entity_id=m.entity_id and m.attribute_id ='149' and a.entity_id=n.entity_id and n.attribute_id ='148' and a.entity_id=i.entity_id and i.attribute_id ='186' and a.entity_id=o.entity_id and o.attribute_id='144' and o.value=p.option_id and p.store_id ='0' and a.entity_id=q.entity_id and q.attribute_id='146' and q.value=r.option_id and r.store_id ='0'


---查询已更新属性默认后台管理员账号
select  a.entity_id,a.名称,a.运维负责人,g.value as 默认后台管理员账号 from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='184' 

---查询已更新属性zabbix监控端口(上架产品)
select  a.entity_id,a.名称,a.运维负责人,g.value as zabbix监控端口 from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='186'

select  a.entity_id,a.名称,a.运维负责人,g.value as zabbix监控端口 from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9' and entity_id not in (select entity_id from v_zabbix_productdown)) and a.entity_id=g.entity_id and g.attribute_id ='186' 
----查询已更新属性数据库类型
select a.entity_id,a.名称,a.运维负责人,p.value as 数据库类型 from v_zabbix_userinfo a ,catalog_product_entity_int o ,eav_attribute_option_value p where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=o.entity_id and o.attribute_id='146' and o.value=p.option_id 
and p.store_id ='0'

----查询已更新属性产品系统架构
select a.entity_id,a.名称,a.运维负责人,p.value as 产品系统架构 from v_zabbix_userinfo a ,catalog_product_entity_int o ,eav_attribute_option_value p where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=o.entity_id and o.attribute_id='144' and o.value=p.option_id 
and p.store_id ='0'


---创建临时表
create temporary table aa select  a.entity_id from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='184'

create temporary table bb select  a.entity_id,a.名称,a.运维负责人  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')

---获取未更新属性默认后台管理员账号产品信息
SELECT * from (select  a.entity_id,a.名称,a.运维负责人  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')) as bb where entity_id not in (SELECT entity_id from (select  a.entity_id from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='184') as aa )

----获取未更新属性zabbix监控端口产品信息
SELECT * from (select  a.entity_id,a.名称,a.运维负责人  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')) as bb where entity_id not in (SELECT entity_id from (select  a.entity_id from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=g.entity_id and g.attribute_id ='186') as aa ) 

SELECT * from (select  a.entity_id,a.名称,a.运维负责人  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9'  and entity_id not in (select entity_id from v_zabbix_productdown))) as bb where entity_id not in (SELECT entity_id from (select  a.entity_id from v_zabbix_userinfo a ,catalog_product_entity_varchar g where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9' and entity_id not in (select entity_id from v_zabbix_productdown)) and a.entity_id=g.entity_id and g.attribute_id ='186' ) as aa ) 

----获取未更新属性数据库类型产品信息
SELECT * from (select  a.entity_id,a.名称,a.运维负责人  from v_zabbix_userinfo a where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9')) as bb where entity_id not in (SELECT entity_id from (select a.entity_id,a.名称,a.运维负责人,p.value as 数据库类型 from v_zabbix_userinfo a ,catalog_product_entity_int o ,eav_attribute_option_value p where a.entity_id in (SELECT entity_id from catalog_product_entity where attribute_set_id like '9') and a.entity_id=o.entity_id and o.attribute_id='146' and o.value=p.option_id and p.store_id ='0') as aa )
----查询多端口数据
select name from v_zabbix_zabbixinfo where ip like '10.228.3.73' and (port like '%,8091' or port like '%,8091,%' or port like '8091,%')
---查询产品名称相同产品
select * from v_zabbix_zabbixinfo where name in (select name from v_zabbix_zabbixinfo group by name having COUNT(*)>1)
(SELECT `value` as name from catalog_product_entity_varchar where attribute_id='71') as aa
select * from (SELECT `value` as name from catalog_product_entity_varchar where attribute_id='71') as aa where name in (select name from (SELECT `value` as name from catalog_product_entity_varchar where attribute_id='71') as aa group by name having COUNT(*)>1)
----查询在线产品名称
select name from v_zabbix_zabbixinfo where entity_id not in(SELECT entity_id from v_zabbix_productdown) ORDER BY updated DESC


