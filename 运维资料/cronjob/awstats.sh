$PERL=/user/bin/perl
awstats=/root/someused/awstats-7.2/wwwroot/cgi-bin/awstats.pl
$PERL $awstats -update -config=www.xxxx.com
$PERL $awstats -config=www.xxxx.com -output -staticlinks > /var/www/awstats/index.html

