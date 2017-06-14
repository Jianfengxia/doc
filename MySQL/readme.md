# MySQL数据库 #
https://dev.mysql.com/doc/refman/5.7/en/what-is-mysql.html
The official way to pronounce “MySQL” is “My Ess Que Ell” (not “my sequel”), but we do not mind if you pronounce it as “my sequel” or in some other localized way. MySQL, the most popular Open Source SQL database management system, ...
MySQL Server系统结构: 连接层、SQL层、存储层

## MySQL命令 ##
1.mysqlbinlog  查看二进制日志，用于查看数据库执行过的内容，用于排查问题和故障恢复
2.mysqladmin (client for administering a MySQL server)  http://blog.csdn.net/radkitty/article/details/4627400
3. /usr/local/mysql/bin/mysqld --defaults-file=/data/mysql/mysql3306/my.cnf & #如果指定了--defaults-file 只会加载指定位置的配置文件

## MySQL环境安装 ##
* minimal cenots配置IP
* my.cnf
* 单、多实例安装
* 实验环境搭建

## MySQL高性能 ##
* Sys库使用

## MySQL-SQL审核-inception ##
http://mysql-inception.github.io/inception-document/

## MySQL-SQL安全 ##
* 审计
* 权限
* MySql-audit

## MySQL备份与恢复 ##
* Linux shell 备份
* Windows shell 备份
* Xtrabackup 热备

## MySQL配置参数 ##
* innodb
* MySQL5.7

## MySQL数据库开发规范 ##
* 知数堂开发规范
* 桔子理财开发规范
* 去哪儿规范

## MySQL监控 ##
* zabbix上MySQL的监控
* Lepus数据库监控系统

## MySQL电子书 ##
跟老男孩学Linux运维：Shell编程实战	老男孩	shell
Beginning Database Design Solutions	Rod Stephens	数据库设计
SQL必知必会(第4版)	Ben Forta 	SQL入门
MySQL技术内幕：InnoDB存储引擎（第2版）	姜承尧	MySQL
MySQL管理之道：性能调优、高可用与监控（第2版）	贺春旸	MySQL
高性能MySQL(第3版)	国外多人	MySQL
