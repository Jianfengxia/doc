#!/usr/bin/env python
# coding: utf-8
import MySQLdb
import datetime
now_time = datetime.datetime.now()
error_time = now_time.strftime('%Y-%m-%d %H:%M:%S')
theday = (now_time + datetime.timedelta(days=+1)).strftime('%Y%m%d')
next_day = (now_time + datetime.timedelta(days=+2)).strftime('%Y-%m-%d')
themonth = datetime.datetime(now_time.year,(now_time.month+1),now_time.day).strftime('%Y%m')
next_month = datetime.datetime(now_time.year,(now_time.month+2),1).strftime('%Y-%m-%d')
last_time = (now_time - datetime.timedelta(days=30)).strftime('%Y%m%d')
last_time_month = datetime.datetime((now_time.year-1),now_time.month,now_time.day).strftime('%Y%m')
events_time = (now_time - datetime.timedelta(days=1)).strftime('%Y-%m-%d')
history_time = (now_time - datetime.timedelta(days=45)).strftime('%Y%m%d')
trends_time = datetime.datetime((now_time.year-1),now_time.month,now_time.day).strftime('%Y%m')
table_day=['history', 'history_uint']
table_month=['trends', 'trends_uint']
conn=MySQLdb.connect(host='localhost',user='zabbix',passwd='zabbix',db='zabbix',port=3306)
cur=conn.cursor()
for name_d in table_day:
   try:
   ####新增分区#######
      cur.execute('ALTER TABLE `%s` ADD PARTITION (PARTITION p%s VALUES LESS THAN (UNIX_TIMESTAMP("%s 00:00:00")))' % (name_d, theday, next_day))
                                                                                                                                                 
   except MySQLdb.Error,e:
       print "[%s] Mysql Error %d: %s" % (error_time, e.args[0], e.args[1])
       pass
for name_m in table_month:
   try:
      ####新增分区#######
      if now_time.day == 20:
         cur.execute('ALTER TABLE `%s` ADD PARTITION (PARTITION p%s VALUES LESS THAN (UNIX_TIMESTAMP("%s 00:00:00")))' % (name_m, themonth, next_month))
   except MySQLdb.Error,e:
       print "[%s] Mysql Error %d: %s" % (error_time, e.args[0], e.args[1])
       pass
######清除events表1天前的数据######
try:
   cur.execute('DELETE FROM `events` where `clock` < UNIX_TIMESTAMP("%s 00:00:00")'% events_time)
   cur.execute('optimize table events;')
except MySQLdb.Error,e:
   print "[%s] Mysql Error %d: %s" % (error_time, e.args[0], e.args[1])
   pass
######清除history,histroy_uint表45天前的数据######
for name_d in table_day:
    try:
       cur.execute('ALTER TABLE `%s` DROP PARTITION p%s;' % (name_d, history_time))
    except MySQLdb.Error,e:
       print "[%s] Mysql Error %d: %s" % (error_time, e.args[0], e.args[1])
       pass
######清除trends,trends_uint表一年前的数据######
for name_m in table_month:
    try:
       cur.execute('ALTER TABLE `%s` DROP PARTITION p%s;' % (name_m, trends_time))
    except MySQLdb.Error,e:
       print "[%s] Mysql Error %d: %s" % (error_time, e.args[0], e.args[1])
       pass
conn.commit()
cur.close()
conn.close()
