#coding: utf-8

import MySQLdb
import re
import os
import time

nowtime=time.strftime('%Y-%m-%d-%H-%M-%S',time.localtime(time.time()))+""

os.system("mysqldump -uzabbix -p@2015 -P3306 -ER zabbix > '/data/mysqlbak/zabbix'"+ nowtime+"'.sql'")
