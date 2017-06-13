DROP VIEW IF EXISTS `v_zabbix_zabbixport`;
DROP VIEW IF EXISTS `v_zabbix_zabbixhostname`;
DROP VIEW IF EXISTS `v_zabbix_zabbixname`;
DROP VIEW IF EXISTS `v_zabbix_zabbixupdated`;
DROP VIEW IF EXISTS `v_zabbix_zabbixinfo`;
DROP VIEW IF EXISTS `v_zabbix_userinfo`;
DROP VIEW IF EXISTS `v_zabbix_productdown`;
DROP VIEW IF EXISTS `v_zabbix_downinfo`;

CREATE  VIEW `v_zabbix_zabbixport`AS select entity_id,value as port from catalog_product_entity_varchar where attribute_id = '186' and value is not null;
CREATE  VIEW `v_zabbix_zabbixhostname`AS select entity_id,value as ip from catalog_product_entity_varchar where entity_id in (select entity_id from v_zabbix_zabbixport) and attribute_id like '162';
CREATE  VIEW `v_zabbix_zabbixname`AS select entity_id,value as name from catalog_product_entity_varchar where entity_id in (select entity_id from v_zabbix_zabbixport) and attribute_id like '71';
CREATE  VIEW `v_zabbix_zabbixupdated`AS select entity_id,updated_at as updated from catalog_product_entity where entity_id in (select entity_id from v_zabbix_zabbixport);
CREATE  VIEW `v_zabbix_zabbixinfo` As  select a.entity_id,a.port,b.ip,c.name,d.updated from v_zabbix_zabbixport as a,v_zabbix_zabbixhostname as b,v_zabbix_zabbixname as c,v_zabbix_zabbixupdated d where a.entity_id=b.entity_id and b.entity_id=c.entity_id and c.entity_id=d.entity_id;
create view `v_zabbix_userinfo` As SELECT DISTINCT a.entity_id,b.`value` as name,c.value as own,d.email,(case WHEN a.`value`='2' then 'disable' else 'enable' end) as status from catalog_product_index_eav a,catalog_product_entity_varchar b ,eav_attribute_option_value as c, v_customer_info d where a.attribute_id like '135' and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.value=c.option_id and c.value in ('Åô','´Ï','»ª','âù','Ö¥','Â«','¾ü') and c.value=d.username ORDER BY own desc;
CREATE  VIEW `v_zabbix_productdown`AS select entity_id,(case WHEN `value`='2' then 'disable' else 'enable' end) as status from catalog_product_entity_int where attribute_id like '96' and `value` like '2';
create view `v_zabbix_downinfo` As SELECT DISTINCT a.entity_id,b.`value` as name,c.value as own,d.email,(case WHEN a.`value`!='2' then 'disable' else 'enable' end) as status   from catalog_product_entity_int a,catalog_product_entity_varchar b ,eav_attribute_option_value as c, v_customer_info d where a.entity_id in (select entity_id from v_zabbix_productdown) and a.entity_id=b.entity_id  and b.attribute_id like '71' and a.attribute_id like '135' and a.value=c.option_id  and  c.value=d.username ORDER BY own desc;