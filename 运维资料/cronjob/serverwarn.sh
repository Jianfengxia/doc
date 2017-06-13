MAIL_TO=jackxia5@gmail.com
STATUS_OK="200"
status="$(curl -o /dev/null -s -m 10 --connect-timeout 10 -w %{http_code} 'http://www.xxx.com/')"
if [ $STATUS_OK != $status ]
then
#service mysql restart
#service varnish restart
#service nginx restart
service apache2 restart
echo "AutoStart:" $(date +"%y-%m-%d %H:%M:%S") "restart server" > /root/autoreboot.log
echo "AutoStart: "$(date +"%y-%m-%d %H:%M:%S")" restart service" | mutt -s "the server is down" $MAIL_TO
else echo 'server is ok.' $(date +"%y-%m-%d %H:%M:%S") > /root/autoreboot.log
fi