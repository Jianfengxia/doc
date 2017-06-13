#!/bin/bash
#rm /home/wwwroot/default/sitemap.xml;

mysql_host="xxx.aliyuncs.com"
mysql_user="mysql_user"
mysql_passwd="mysql_passwd"
DB_name="DB_name"

/usr/bin/mysql -u${mysql_user} -h${mysql_host} -p${mysql_passwd} -e "use DB_name; select * from sitemap;" > /home/wwwroot/default/sitemap.xml

#chmod 777 /home/wwwroot/www.xxx.com/feed/*;

#mutt -s "xxx: sitemap"  jackxia5@xx.com -a /home/wwwroot/default/sitemap.xml;

#/usr/bin/mysql -uroot -h localhost -pXxx -e "use xxx; select * INTO OUTFILE '/home/wwwroot/default/sitemap.xml' from sitemap;"