DROP VIEW IF EXISTS `v_port_hostid`;
DROP VIEW IF EXISTS `v_port_itemid`;
DROP VIEW IF EXISTS `v_port_hourdata`;
DROP VIEW IF EXISTS `v_port_hourenable`;
DROP VIEW IF EXISTS `v_port_daydata`;
DROP VIEW IF EXISTS `v_port_dayenable`;
DROP VIEW IF EXISTS `v_port_monthdata`;
DROP VIEW IF EXISTS `v_port_monthenable`;
DROP VIEW IF EXISTS `v_port_totaldata`;
DROP VIEW IF EXISTS `v_port_totalenable`;



create view v_port_hostid As SELECT hostid ,host from hosts where host LIKE '10%' or host LIKE'192%';
create view v_port_itemid As select DISTINCT a.itemid,b.host,a.name from items a ,v_port_hostid b where a.hostid =b.hostid  and a.key_ like 'net.tcp%' ;
create view v_port_hourdata As SELECT a.itemid,c.host,c.name,a.clock,a.num as total,b.num as fail_num from trends as a,trends_port_low as b, v_port_itemid as c where a.itemid =c.itemid and a.itemid =b.itemid and a.clock=b.clock;
create view v_port_hourenable As select itemid,host,name,FROM_UNIXTIME(clock,'%Y-%m-%d %H:%i:%S') as clock,concat(cast(abs((left(1-fail_num/total,4)))*100 as char),'%' )as enable from v_port_hourdata order by abs((left(1-fail_num/total,4)))*100;
create view v_port_daydata As SELECT  itemid,host,name,FROM_UNIXTIME(clock, '%Y-%m-%d' ) as day ,sum(total) as total, sum(fail_num) as fail_num from v_port_hourdata  group by itemid,FROM_UNIXTIME(clock, '%Y-%m-%d' );
create view v_port_dayenable As select itemid,host,name,day,concat(cast(abs((left(1-fail_num/total,4)))*100 as char),'%' )as enable from v_port_daydata order by abs((left(1-fail_num/total,4)))*100;
create view v_port_monthdata As SELECT  itemid,host,name,FROM_UNIXTIME(clock, '%Y-%m' ) as month ,sum(total) as total, sum(fail_num) as fail_num from v_port_hourdata group by itemid,FROM_UNIXTIME(clock, '%Y-%m' );
create view v_port_monthenable As select itemid,host,name,month,concat(cast(abs((left(1-fail_num/total,4)))*100 as char),'%' )as enable from v_port_monthdata order by abs((left(1-fail_num/total,4)))*100 ;
create view v_port_totaldata As SELECT  itemid,host,name,sum(total) as total, sum(fail_num) as fail_num from v_port_hourdata group by itemid;
create view v_port_totalenable As select itemid,host,name,concat(cast((abs((left(1-fail_num/total,4))))*100 as char),'%' )as enable from v_port_totaldata order by abs((left(1-fail_num/total,4)))*100;
