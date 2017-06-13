
rm /home/wwwroot/www.xxx.com/feed/*;

mysql_host="localhost"
mysql_user="root"
mysql_passwd="mysql_passwd"
DB_name="DB_name"

/usr/bin/mysql -u${mysql_user} -h${mysql_host} -p${mysql_passwd} -e "use xxx_com;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_au.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_au;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_ca.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_ca;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_de.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_de;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_es.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_es;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_fr.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_fr;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_it.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_it;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_jp.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_jp;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_nl.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_nl;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_pt.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_pt;
select * INTO OUTFILE '/home/wwwroot/www.xxx.com/feed/prd_google_feed_uk.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' from prd_google_feed_uk;"

chmod 777 /home/wwwroot/www.xxx.com/feed/*;

mutt -s "xxx: prd_google_feed"  jack@xxx.com -a /home/wwwroot/www.xxx.com/feed/prd_google_feed.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_au.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_ca.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_de.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_es.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_fr.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_it.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_jp.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_nl.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_pt.txt -a /home/wwwroot/www.xxx.com/feed/prd_google_feed_uk.txt;