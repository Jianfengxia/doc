#!/bin/bash
. /etc/profile
logdir='/tmp/zabbix_log'
mysql_host='10.1.**.**'
mysql_user='mysql_user'
mysql_passwd='mysql_passwd'
mysql_database='zabbix'
year=`date +%Y`
month=`date +%m`
next_month=`echo $month+1|bc`
if [ ! -d $logdir ];then
    mkdir $logdir
fi
##zabbix host month report
#select cpu avg idle
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_cpu_avg_idle.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host, round(avg(hi.value_avg),1) as Cpu_Avg_Idle  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends hi on  i.itemid = hi.itemid  where  i.key_='system.cpu.util[,idle]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select cpu min idle
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_cpu_min_idle.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host, round(min(hi.value_avg),1) as Cpu_Min_Idle  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends hi on  i.itemid = hi.itemid  where  i.key_='system.cpu.util[,idle]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select cpu number
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_cpu_number.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg),0) as Cpu_Number  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='system.cpu.num' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '1d' $logdir/info_mysql_cpu_avg_idle.txt
sed -i '1d' $logdir/info_mysql_cpu_number.txt
sed -i '1d' $logdir/info_mysql_cpu_min_idle.txt
awk 'NR==FNR{a[$1,$2,$3]=$4;next}{print $0,a[$1,$2,$3]}' $logdir/info_mysql_cpu_avg_idle.txt $logdir/info_mysql_cpu_number.txt |awk '{if($5<$4) {print $1"\t"$2"\t"$3"\t"$4"\t""99.00"} else {print $0}}'>$logdir/info_zabbix_cpu_reslut.txt
#select cpu min iowait
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_cpu_min_iowait.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host, round(min(hi.value_avg),1) as Cpu_Min_Iowait  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends hi on  i.itemid = hi.itemid  where  i.key_='system.cpu.util[,iowait]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select cpu max iowait
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_cpu_max_iowait.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host, round(max(hi.value_max),1) as Cpu_Max_Iowait  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends hi on  i.itemid = hi.itemid  where  i.key_='system.cpu.util[,iowait]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select cpu max load 5 minute
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_cpu_max_load5.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host, round(max(hi.value_max),0) as Cpu_Max_Iowait  from hosts_groups hg join groups g on g.groupid = hg.groupid 
join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends hi on  i.itemid = hi.itemid  where  i.key_='system.cpu.load[all,avg5]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select memory avg avaiable
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_memory_avg_avaiable.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1024/1024/1024,1) as Memory_Avaiable  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='vm.memory.size[available]'  and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select memory min avaiable
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_memory_min_avaiable.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1024/1024/1024,1) as Memory_Avaiable  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='vm.memory.size[available]'  and  hi.clock >=
 UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select memory avg free
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_memory_avg_free.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1024/1024/1024,1) as Memory_Avaiable  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='vm.memory.size[free]'  and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select memory min free
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_memory_min_free.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1024/1024/1024,1) as Memory_Avaiable  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='vm.memory.size[free]'  and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select memory total
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_memory_total.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1024/1024/1024,0) as Memory_Total  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='vm.memory.size[total]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '1d' $logdir/info_mysql_memory_avg_avaiable.txt
sed -i '1d' $logdir/info_mysql_memory_avg_free.txt
sed -i '1d' $logdir/info_mysql_memory_total.txt
#merge memory_avg_free
cat $logdir/info_mysql_memory_avg_avaiable.txt $logdir/info_mysql_memory_avg_free.txt > $logdir/info_mysql_memory_all_avg_free.txt
awk 'NR==FNR{a[$1,$2,$3]=$4;next}{print $0,a[$1,$2,$3]}' $logdir/info_mysql_memory_total.txt $logdir/info_mysql_memory_all_avg_free.txt >$logdir/info_zabbix_memory_avg_result.txt
#merge memory_min_free
cat $logdir/info_mysql_memory_min_avaiable.txt $logdir/info_mysql_memory_min_free.txt > $logdir/info_mysql_memory_all_min_free.txt
sed -i '1d'  $logdir/info_mysql_memory_all_min_free.txt
#merge cpu_min_idle and cpu_min_iowait
awk 'NR==FNR{a[$1,$2,$3]=$4;next}{print $0,a[$1,$2,$3]}' $logdir/info_mysql_cpu_min_iowait.txt  $logdir/info_mysql_cpu_min_idle.txt>$logdir/info_zabbix_cpu_min_idle_and_iowait.txt
#merge cpu_max_iowait and cpu_max_load5
awk 'NR==FNR{a[$1,$2,$3]=$4;next}{print $0,a[$1,$2,$3]}' $logdir/info_mysql_cpu_max_iowait.txt  $logdir/info_mysql_cpu_max_load5.txt >$logdir/info_zabbix_cpu_max_load5_and_iowait.txt
#merge cpu_min_idle_and_iowait and cpu_max_load5_and_iowait
awk 'NR==FNR{a[$1,$2,$3]=$4"\t"$5;next}{print $0,a[$1,$2,$3]}' $logdir/info_zabbix_cpu_max_load5_and_iowait.txt $logdir/info_zabbix_cpu_min_idle_and_iowait.txt>$logdir/info_zabbix_cpu_idle_and_iowait.txt
#select network windows avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_windows_avg_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1000,0) as Network_Windows_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network windows avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_windows_avg_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1000,0) as Network_Windows_Avg_Out from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[Broadcom NetXtreme Gigabit Ethernet#2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_windows_avg_in.txt $logdir/info_mysql_network_windows_avg_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_windows_avg.txt
#select network windows min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_windows_min_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Windows_Min_In  from hosts_groups hg join groups g on g.groupid 
= hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network windows min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_windows_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Windows_Min_Out from hosts_groups hg join groups g on g.groupid 
= hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[Broadcom NetXtreme Gigabit Ethernet#2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_windows_min_in.txt $logdir/info_mysql_network_windows_min_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_windows_min.txt
#select network windows max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_windows_max_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(max(hi.value_max)/1000,0) as Network_Windows_Max_In  from hosts_groups hg join groups g on g.groupid 
= hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network windows max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_windows_max_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(max(hi.value_max)/1000,0) as Network_Windows_Max_Out from hosts_groups hg join groups g on g.groupid 
= hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_windows_max_in.txt $logdir/info_mysql_network_windows_max_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_windows_max.txt
#select network em2 avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_em2_avg_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1000,0) as Network_Em2_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '/Date*/d' $logdir/info_mysql_network_em2_avg_in.txt
#select network em2 avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_em2_avg_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1000,0) as Network_Em2_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '/Date*/d' $logdir/info_mysql_network_em2_avg_in.txt
paste $logdir/info_mysql_network_em2_avg_in.txt $logdir/info_mysql_network_em2_avg_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_em2_avg.txt
#select network em2 min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_em2_min_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Em2_Min_In  from hosts_groups hg join groups g on g.groupid = hg
.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '/Date*/d' $logdir/info_mysql_network_em2_min_in.txt
#select network em2 min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_em2_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Em2_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[em2]' and  hi.clock >= UNIX_TIMESTAMP(
'${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '/Date*/d' $logdir/info_mysql_network_em2_min_out.txt
#select network em2 min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_em2_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Em2_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[em2]' and  hi.clock >= UNIX_TIMESTAMP(
'${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '/Date*/d' $logdir/info_mysql_network_em2_min_out.txt
paste $logdir/info_mysql_network_em2_min_in.txt $logdir/info_mysql_network_em2_min_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_em2_min.txt
#select network em2 max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_em2_max_in.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(max(hi.value_max)/1000,0) as Network_Em2_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '/Date*/d' $logdir/info_mysql_network_em2_max_in.txt
#select network em2 max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_em2_max_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(max(hi.value_max)/1000,0) as Network_Em2_Max_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[em2]' and  hi.clock >= UNIX_TIMESTAMP(
'${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
sed -i '/Date*/d'  $logdir/info_mysql_network_em2_max_out.txt
paste $logdir/info_mysql_network_em2_max_in.txt $logdir/info_mysql_network_em2_max_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_em2_max.txt
#select network eth1 avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth1_avg_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1000,0) as Network_Eth1_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network eth1 avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth1_avg_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1000,0) as Network_Eth1_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_eth1_avg_in.txt $logdir/info_mysql_network_eth1_avg_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_eth1_avg.txt
#select network eth1 min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth1_min_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Eth1_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth1]' and  hi.clock >= UNIX_TIMESTAMP(
'${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network eth1 min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth1_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Eth1_Min_Out  from hosts_groups hg join groups g on g.groupid = 
hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_eth1_min_in.txt $logdir/info_mysql_network_eth1_min_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_eth1_min.txt
#select network eth1 max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth1_max_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(max(hi.value_max)/1000,0) as Network_Eth1_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth1]' and  hi.clock >= UNIX_TIMESTAMP(
'${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network eth1 max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth1_max_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(max(hi.value_max)/1000,0) as Network_Eth1_Max_Out  from hosts_groups hg join groups g on g.groupid = 
hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_eth1_max_in.txt $logdir/info_mysql_network_eth1_max_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_eth1_max.txt
#select network eth0 avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth0_avg_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1000,0) as Network_Eth0_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network eth0 avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth0_avg_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(avg(hi.value_avg)/1000,0) as Network_Eth0_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_eth0_avg_in.txt $logdir/info_mysql_network_eth0_avg_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_eth0_avg.txt
#select network eth0 min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth0_min_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Eth0_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth0]' and  hi.clock >= UNIX_TIMESTAMP(
'${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network eth0 min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth0_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(min(hi.value_avg)/1000,0) as Network_Eth0_Min_Out  from hosts_groups hg join groups g on g.groupid = 
hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_eth0_min_in.txt $logdir/info_mysql_network_eth0_min_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_eth0_min.txt
#select network eth0 max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth0_max_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(max(hi.value_max)/1000,0) as Network_Eth0_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth0]' and  hi.clock >= UNIX_TIMESTAMP(
'${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
#select network eth0 max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/info_mysql_network_eth0_max_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,h.host as Host,round(max(hi.value_max)/1000,0) as Network_Eth0_Max_Out  from hosts_groups hg join groups g on g.groupid = 
hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by h.host;
EOF
paste $logdir/info_mysql_network_eth0_max_in.txt $logdir/info_mysql_network_eth0_max_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/info_mysql_network_eth0_max.txt
#merge eth1 and eth0 network avg
 awk '{print "sed -i /"$3"/d  '$logdir'/info_mysql_network_eth0_avg.txt"}' $logdir/info_mysql_network_eth1_avg.txt  > $logdir/info_mysql_network_eth0_avg_sed.sh
sed -i -e 's@-i /@-i "/*@g' -e 's@/d@*/d"@g' $logdir/info_mysql_network_eth0_avg_sed.sh
/bin/bash $logdir/info_mysql_network_eth0_avg_sed.sh
cat $logdir/info_mysql_network_windows_avg.txt $logdir/info_mysql_network_em2_avg.txt $logdir/info_mysql_network_eth1_avg.txt $logdir/info_mysql_network_eth0_avg.txt > $logdir/info_mysql_network_avg.txt
sed -i '1d'  $logdir/info_mysql_network_avg.txt
#merge eth1 and eth0 network min
 awk '{print "sed -i /"$3"/d  '$logdir'/info_mysql_network_eth0_min.txt"}' $logdir/info_mysql_network_eth1_min.txt  > $logdir/info_mysql_network_eth0_min_sed.sh
sed -i -e 's@-i /@-i "/*@g' -e 's@/d@*/d"@g' $logdir/info_mysql_network_eth0_min_sed.sh
/bin/bash $logdir/info_mysql_network_eth0_min_sed.sh
cat $logdir/info_mysql_network_windows_min.txt $logdir/info_mysql_network_em2_min.txt $logdir/info_mysql_network_eth1_min.txt $logdir/info_mysql_network_eth0_min.txt > $logdir/info_mysql_network_min.txt
sed -i '1d' $logdir/info_mysql_network_min.txt
#merge eth1 and eth0 network max
 awk '{print "sed -i /"$3"/d  '$logdir'/info_mysql_network_eth0_max.txt"}' $logdir/info_mysql_network_eth1_max.txt  > $logdir/info_mysql_network_eth0_max_sed.sh
sed -i -e 's@-i /@-i "/*@g' -e 's@/d@*/d"@g' $logdir/info_mysql_network_eth0_max_sed.sh
/bin/bash $logdir/info_mysql_network_eth0_max_sed.sh
cat $logdir/info_mysql_network_windows_max.txt $logdir/info_mysql_network_em2_max.txt $logdir/info_mysql_network_eth1_max.txt $logdir/info_mysql_network_eth0_max.txt > $logdir/info_mysql_network_max.txt
sed -i '1d' $logdir/info_mysql_network_max.txt
#merge cpu and memory
awk 'NR==FNR{a[$1,$2,$3]=$4"\t"$5;next}{print $0,a[$1,$2,$3]}' $logdir/info_zabbix_memory_avg_result.txt $logdir/info_zabbix_cpu_reslut.txt>$logdir/info_zabbix_memory_cpu_result.txt
#merge cpu_number   cpu_avg_idle  memory_avg_free memory_total cpu_min_idle cpu_min_iowait cpu_max_load5 cpu_max_iowait
awk 'NR==FNR{a[$1,$2,$3]=$4"\t"$5"\t"$6"\t"$7;next}{print $0,a[$1,$2,$3]}' $logdir/info_zabbix_cpu_idle_and_iowait.txt $logdir/info_zabbix_memory_cpu_result.txt|awk '{if($8 == " ") {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t0.0\t0.0\t9\t0.1"} else {print $0}}' > $logdir/info_zabbix_all_cpu.txt
#megre cpu_number   cpu_avg_idle  memory_avg_free memory_total cpu_min_idle cpu_min_iowait cpu_max_load5 cpu_max_iowait memory_min_free
awk 'NR==FNR{a[$1,$2,$3]=$NF;next}{print $0,a[$1,$2,$3]}' $logdir/info_mysql_memory_all_min_free.txt $logdir/info_zabbix_all_cpu.txt >$logdir/info_zabbix_all_cpu_and_memory.txt
#merge network avg and min
awk 'NR==FNR{a[$1,$2,$3]=$4"\t"$5;next}{print $0,a[$1,$2,$3]}' $logdir/info_mysql_network_min.txt $logdir/info_mysql_network_avg.txt >$logdir/info_zabbix_network_avg_and_min.txt
#merge network max and avg_min
awk 'NR==FNR{a[$1,$2,$3]=$4"\t"$5"\t"$6"\t"$7;next}{print $0,a[$1,$2,$3]}' $logdir/info_mysql_network_max.txt $logdir/info_zabbix_network_avg_and_min.txt >$logdir/info_mysql_network_all.txt
#merge cpu and memory and network
#awk 'NR==FNR{a[$1,$2,$3]=$4"\t"$5"\t"$6"\t"$7;next}{print $0,a[$1,$2,$3]}' $logdir/info_mysql_network_avg.txt $logdir/info_zabbix_memory_cpu_result.txt| awk '{if($8<0) {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"5"\t"8} else {print $0}}'|sort -k2r >$logdir/zabbix_host_search.txt
awk 'NR==FNR{a[$1,$2,$3]=$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9;next}{print $0,a[$1,$2,$3]}'  $logdir/info_mysql_network_all.txt $logdir/info_zabbix_all_cpu_and_memory.txt >$logdir/info_zabbix_host_all.txt
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$8"\t"$6"\t"$12"\t"$7"\t"$9"\t"$11"\t"$10"\t"$17"\t"$18"\t"$13"\t"$14"\t"$15"\t"$16}' $logdir/info_zabbix_host_all.txt|sort -k2r >$logdir/zabbix_host_search.txt
sed -i '1i 日期\t所属组\t主机ip\tcpu逻辑核数(单位:个)\tcpu平均空闲值(单位:%)\tcpu最小空闲值(单位:%)\t可用平均内存(单位:GB)\t可用最小内存(单位:GB)\t总内存值(单位:GB)\tcpu最小wio(单位:%)\tcpu最大wio(单位:%)\tcpu5分钟最大负载\t进入最大流量(单位:kbps)\t出去最大流量(单位:kbps)\t进入平均流量(单位:kbps)\t出去平均流量(单位:kbps)\t进入最小流量(单位:kbps)\t出去最小流量(单位:kbps)' $logdir/zabbix_host_search.txt
rm -rf $logdir/info*.txt
rm -rf $logdir/info*.sh
##zabbix group month report
#select network em2 avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_em2_avg_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(avg(hi.value_avg)/1000,0) as Network_Em2_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '/Date*/d' $logdir/group_mysql_network_em2_avg_in.txt
#select network em2 avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_em2_avg_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(avg(hi.value_avg)/1000,0) as Network_Em2_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '/Date*/d' $logdir/group_mysql_network_em2_avg_out.txt
#paste $logdir/group_mysql_network_em2_in.txt $logdir/group_mysql_network_em2_out.txt |awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$NF}' >$logdir/group_mysql_network_em2.txt
sed -i '1d' $logdir/group_mysql_network_em2_avg_in.txt
#sed -i '1d' $logdir/group_mysql_network_em2_avg_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}'  $logdir/group_mysql_network_em2_avg_out.txt $logdir/group_mysql_network_em2_avg_in.txt >$logdir/group_mysql_network_em2_avg.txt
#select network em2 max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_em2_max_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(max(hi.value_max)/1000,0) as Network_Em2_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '/Date*/d' $logdir/group_mysql_network_em2_max_in.txt
#select network em2 max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_em2_max_out.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(max(hi.value_max)/1000,0) as Network_Em2_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '/Date*/d' $logdir/group_mysql_network_em2_max_out.txt
sed -i '1d' $logdir/group_mysql_network_em2_max_in.txt
#sed -i '1d' $logdir/group_mysql_network_em2_max_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}'  $logdir/group_mysql_network_em2_max_out.txt $logdir/group_mysql_network_em2_max_in.txt >$logdir/group_mysql_network_em2_max.txt
#select network em2 min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_em2_min_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Em2_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '/Date*/d'  $logdir/group_mysql_network_em2_min_in.txt
#select network em2 min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_em2_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Em2_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[em2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '/Date*/d' $logdir/group_mysql_network_em2_min_out.txt
sed -i '1d' $logdir/group_mysql_network_em2_min_in.txt
#sed -i '1d' $logdir/group_mysql_network_em2_min_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}'  $logdir/group_mysql_network_em2_min_out.txt $logdir/group_mysql_network_em2_min_in.txt >$logdir/group_mysql_network_em2_min.txt
#select network eth1 avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth1_avg_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(avg(hi.value_avg)/1000,0) as Network_Eth1_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network eth1 avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth1_avg_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(avg(hi.value_avg)/1000,0) as Network_Eth1_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '1d' $logdir/group_mysql_network_eth1_avg_in.txt
sed -i '1d' $logdir/group_mysql_network_eth1_avg_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_eth1_avg_out.txt $logdir/group_mysql_network_eth1_avg_in.txt>$logdir/group_mysql_network_eth1_avg.txt
#select network eth1 max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth1_max_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(max(hi.value_max)/1000,0) as Network_Eth1_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network eth1 max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth1_max_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(max(hi.value_max)/1000,0) as Network_Eth1_Max_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '1d' $logdir/group_mysql_network_eth1_max_in.txt
sed -i '1d' $logdir/group_mysql_network_eth1_max_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_eth1_max_out.txt $logdir/group_mysql_network_eth1_max_in.txt>$logdir/group_mysql_network_eth1_max.txt
#select network eth1 min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth1_min_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Eth1_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network eth1 min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth1_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Eth1_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join
 items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth1]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '1d' $logdir/group_mysql_network_eth1_min_in.txt
sed -i '1d' $logdir/group_mysql_network_eth1_min_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_eth1_min_out.txt $logdir/group_mysql_network_eth1_min_in.txt>$logdir/group_mysql_network_eth1_min.txt
#select network eth0 avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth0_avg_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(avg(hi.value_avg)/1000,0) as Network_Eth0_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network eth0 avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth0_avg_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(avg(hi.value_avg)/1000,0) as Network_Eth0_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '1d' $logdir/group_mysql_network_eth0_avg_in.txt
sed -i '1d' $logdir/group_mysql_network_eth0_avg_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_eth0_avg_out.txt $logdir/group_mysql_network_eth0_avg_in.txt  >$logdir/group_mysql_network_eth0_avg.txt
awk '{print "sed -i /"$3"/d  '$logdir'/group_mysql_network_eth0_avg.txt"}' $logdir/group_mysql_network_eth1_avg.txt  > $logdir/group_mysql_network_eth0_avg_sed.sh
sed -i -e 's@-i /@-i "/*@g' -e 's@/d@*/d"@g' $logdir/group_mysql_network_eth0_avg_sed.sh
/bin/bash $logdir/group_mysql_network_eth0_avg_sed.sh
#select network eth0 max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth0_max_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(max(hi.value_max)/1000,0) as Network_Eth0_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network eth0 max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth0_max_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(max(hi.value_max)/1000,0) as Network_Eth0_Max_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join
 items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '1d' $logdir/group_mysql_network_eth0_max_in.txt
sed -i '1d' $logdir/group_mysql_network_eth0_max_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_eth0_max_out.txt $logdir/group_mysql_network_eth0_max_in.txt  >$logdir/group_mysql_network_eth0_max.txt
awk '{print "sed -i /"$3"/d  '$logdir'/group_mysql_network_eth0_max.txt"}' $logdir/group_mysql_network_eth1_max.txt  > $logdir/group_mysql_network_eth0_max_sed.sh
sed -i -e 's@-i /@-i "/*@g' -e 's@/d@*/d"@g' $logdir/group_mysql_network_eth0_max_sed.sh
/bin/bash $logdir/group_mysql_network_eth0_max_sed.sh
#select network eth0 min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth0_min_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Eth0_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network eth0 min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_eth0_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Eth0_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join
 items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[eth0]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
sed -i '1d' $logdir/group_mysql_network_eth0_min_in.txt
sed -i '1d' $logdir/group_mysql_network_eth0_min_out.txt
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_eth0_min_out.txt $logdir/group_mysql_network_eth0_min_in.txt  >$logdir/group_mysql_network_eth0_min.txt
#select network windows min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_win_min_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Win_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network windows min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_win_min_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Win_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_win_min_out.txt $logdir/group_mysql_network_win_min_in.txt  >$logdir/group_mysql_network_win_min.txt
sed -i '/Date^*/d' $logdir/group_mysql_network_win_min.txt
#select network windows max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_win_max_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(max(hi.value_max)/1000,0) as Network_Win_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network windows max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_win_max_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(max(hi.value_max)/1000,0) as Network_Win_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_win_max_out.txt $logdir/group_mysql_network_win_max_in.txt  >$logdir/group_mysql_network_win_max.txt
sed -i '/Date^*/d' $logdir/group_mysql_network_win_max.txt
#select network windows avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_win_avg_in.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Win_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.in[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
#select network windows avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/group_mysql_network_win_avg_out.txt<<EOF
set names utf8;
 select from_unixtime(hi.clock,'%Y-%m') as Date,g.name as Group_Name,round(min(hi.value_avg)/1000,0) as Network_Win_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where  i.key_='net.if.out[Broadcom NetXtreme Gigabit Ethernet #2]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and  hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00') group by g.name;
EOF
awk 'NR==FNR{a[$1,$2]=$3;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_win_avg_out.txt $logdir/group_mysql_network_win_avg_in.txt  >$logdir/group_mysql_network_win_avg.txt
sed -i '/Date^*/d' $logdir/group_mysql_network_win_avg.txt
#delete eth0 ip from eth1 network min
awk '{print "sed -i /"$2"/d  '$logdir'/group_mysql_network_eth0_min.txt"}' $logdir/group_mysql_network_eth1_min.txt  > $logdir/group_mysql_network_eth0_min_sed.sh
sed -i -e 's@-i /@-i "/@g' -e 's@/d@/d"@g' $logdir/group_mysql_network_eth0_min_sed.sh
/bin/bash $logdir/group_mysql_network_eth0_min_sed.sh
#delete eth0 ip from eth1 network max
awk '{print "sed -i /"$2"/d  '$logdir'/group_mysql_network_eth0_max.txt"}' $logdir/group_mysql_network_eth1_max.txt  > $logdir/group_mysql_network_eth0_max_sed.sh
sed -i -e 's@-i /@-i "/@g' -e 's@/d@/d"@g' $logdir/group_mysql_network_eth0_max_sed.sh
/bin/bash $logdir/group_mysql_network_eth0_max_sed.sh
#delete eth0 ip from eth1 network avg
awk '{print "sed -i /"$2"/d  '$logdir'/group_mysql_network_eth0_avg.txt"}' $logdir/group_mysql_network_eth1_avg.txt  > $logdir/group_mysql_network_eth0_avg_sed.sh
sed -i -e 's@-i /@-i "/@g' -e 's@/d@/d"@g' $logdir/group_mysql_network_eth0_avg_sed.sh
/bin/bash $logdir/group_mysql_network_eth0_avg_sed.sh
#merge group network avg
cat $logdir/group_mysql_network_win_avg.txt $logdir/group_mysql_network_em2_avg.txt $logdir/group_mysql_network_eth1_avg.txt $logdir/group_mysql_network_eth0_avg.txt > $logdir/group_mysql_network_avg.txt
#merge group network max
cat $logdir/group_mysql_network_win_max.txt $logdir/group_mysql_network_em2_max.txt $logdir/group_mysql_network_eth1_max.txt $logdir/group_mysql_network_eth0_max.txt > $logdir/group_mysql_network_max.txt
#merge group network min
cat $logdir/group_mysql_network_win_min.txt $logdir/group_mysql_network_em2_min.txt $logdir/group_mysql_network_eth1_min.txt $logdir/group_mysql_network_eth0_min.txt > $logdir/group_mysql_network_min.txt
#merge group network max and avg
awk 'NR==FNR{a[$1,$2]=$3"\t"$4;next}{print $0,a[$1,$2]}'   $logdir/group_mysql_network_avg.txt  $logdir/group_mysql_network_max.txt >$logdir/group_zabbix_network_max_and_avg.txt
#merge group network max avg min
awk 'NR==FNR{a[$1,$2]=$3"\t"$4;next}{print $0,a[$1,$2]}' $logdir/group_mysql_network_min.txt $logdir/group_zabbix_network_max_and_avg.txt >$logdir/zabbix_group_network_traffic.txt
sed -i '1i 日期\t所属组\t进入最大流量(单位:kbps)\t出去最大流量(单位:kbps)\t进入平均流量(单位:kbps)\t出去平均流量(单位:kbps)\t进入最小流量(单位:kbps)\t出去最小流量(单位:kbps)'  $logdir/zabbix_group_network_traffic.txt
rm -rf $logdir/group*.txt
rm -rf $logdir/group*.sh
##zabbix room network  report
#select sjhl network avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_sjhl_avg_in.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(avg(hi.value_avg)/1000/1000,0) as Network_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='10.10.100.254' and  i.key_='ifInOctets[GigabitEthernet1/1/3]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select sjhl network avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_sjhl_avg_out.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(avg(hi.value_avg)/1000/1000,0) as Network_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='10.10.100.254' and  i.key_='ifOutOctets[GigabitEthernet1/1/3]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select sjhl network max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_sjhl_max_in.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(max(hi.value_max)/1000/1000,0) as Network_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='10.10.100.254' and  i.key_='ifInOctets[GigabitEthernet1/1/3]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select sjhl network max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_sjhl_max_out.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(max(hi.value_max)/1000/1000,0) as Network_Max_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='10.10.100.254' and  i.key_='ifOutOctets[GigabitEthernet1/1/3]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select sjhl network min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_sjhl_min_in.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(min(hi.value_avg)/1000/1000,0) as Network_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='10.10.100.254' and  i.key_='ifInOctets[GigabitEthernet1/1/3]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select sjhl network min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_sjhl_min_out.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(min(hi.value_avg)/1000/1000,0) as Network_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='10.10.100.254' and  i.key_='ifOutOctets[GigabitEthernet1/1/3]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select lugu network avg in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_lugu_avg_in.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(avg(hi.value_avg)/1000/1000,0) as Network_Avg_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='LG-Network-External-GW' and  i.key_='ifInOctets[Port-channel9]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select lugu network avg out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_lugu_avg_out.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(avg(hi.value_avg)/1000/1000,0) as Network_Avg_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='LG-Network-External-GW' and  i.key_='ifOutOctets[Port-channel9]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select lugu network min in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_lugu_min_in.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(min(hi.value_avg)/1000/1000,0) as Network_Min_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='LG-Network-External-GW' and  i.key_='ifInOctets[Port-channel9]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select lugu network min out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_lugu_min_out.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(min(hi.value_avg)/1000/1000,0) as Network_Min_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='LG-Network-External-GW' and  i.key_='ifOutOctets[Port-channel9]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select lugu network max in
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_lugu_max_in.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(max(hi.value_max)/1000/1000,0) as Network_Max_In  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='LG-Network-External-GW' and  i.key_='ifInOctets[Port-channel9]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#select lugu network max out
mysql -h $mysql_host  -u $mysql_user -p$mysql_passwd $mysql_database >$logdir/room_mysql_network_lugu_max_out.txt<<EOF
set names utf8;
select from_unixtime(hi.clock,'%Y-%m') as Date,h.name as Hostname,round(max(hi.value_max)/1000/1000,0) as Network_Max_Out  from hosts_groups hg join groups g on g.groupid = hg.groupid join items i on hg.hostid = i.hostid join hosts h on h.hostid=i.hostid join trends_uint hi on  i.itemid = hi.itemid  where h.host='LG-Network-External-GW' and  i.key_='ifOutOctets[Port-channel9]' and  hi.clock >= UNIX_TIMESTAMP('${year}-${month}-01 00:00:00') and   hi.clock < UNIX_TIMESTAMP('${year}-0${next_month}-01 00:00:00');
EOF
#merge sjhl network
paste  $logdir/room_mysql_network_sjhl_avg_in.txt  $logdir/room_mysql_network_sjhl_avg_out.txt |awk 'NR==2{print $1"\t"$2"\t"$3"\t"$NF}'>$logdir/room_mysql_sjhl_network_avg.txt
paste  $logdir/room_mysql_network_sjhl_max_in.txt  $logdir/room_mysql_network_sjhl_max_out.txt |awk 'NR==2{print $1"\t"$2"\t"$3"\t"$NF}'>$logdir/room_mysql_sjhl_network_max.txt
paste  $logdir/room_mysql_network_sjhl_min_in.txt  $logdir/room_mysql_network_sjhl_min_out.txt |awk 'NR==2{print $1"\t"$2"\t"$3"\t"$NF}'>$logdir/room_mysql_sjhl_network_min.txt
#merge lugu network
paste  $logdir/room_mysql_network_lugu_avg_in.txt  $logdir/room_mysql_network_lugu_avg_out.txt |awk 'NR==2{print $1"\t"$2"\t"$3"\t"$NF}'>$logdir/room_mysql_lugu_network_avg.txt
paste  $logdir/room_mysql_network_lugu_max_in.txt  $logdir/room_mysql_network_lugu_max_out.txt |awk 'NR==2{print $1"\t"$2"\t"$3"\t"$NF}'>$logdir/room_mysql_lugu_network_max.txt
paste  $logdir/room_mysql_network_lugu_min_in.txt  $logdir/room_mysql_network_lugu_min_out.txt |awk 'NR==2{print $1"\t"$2"\t"$3"\t"$NF}'>$logdir/room_mysql_lugu_network_min.txt
#merge sjhl network max avg min
paste $logdir/room_mysql_sjhl_network_max.txt $logdir/room_mysql_sjhl_network_avg.txt  $logdir/room_mysql_sjhl_network_min.txt|awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$7"\t"$8"\t"$11"\t"$12}' >$logdir/room_mysql_sjhl_network_all.txt
#merge lugu network max avg min
paste $logdir/room_mysql_lugu_network_max.txt $logdir/room_mysql_lugu_network_avg.txt  $logdir/room_mysql_lugu_network_min.txt|awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$7"\t"$8"\t"$11"\t"$12}' >$logdir/room_mysql_lugu_network_all.txt
cat $logdir/room_mysql_sjhl_network_all.txt $logdir/room_mysql_lugu_network_all.txt  |awk 'BEGIN{print "日期\t机房\t进入最大流量(单位:Mbps)\t出去最大流量(单位:Mbps)\t进入平均流量(单位:Mbps)\t出去平均流量(单位:Mbps)\t进入最小流量(单位:Mbps)\t出去最小流量(单位:Mbps)"}{print $0}' >$logdir/zabbix_room_network.txt
rm -rf $logdir/room*.txt
##zabbix network avg percent
awk -v lugu_in=`awk '$2~/鲁谷/{print $5*1000}' $logdir/zabbix_room_network.txt` -v lugu_out=`awk '$2~/鲁谷/{print $6*1000}' $logdir/zabbix_room_network.txt` -v sjhl_in=`awk '$2~/世纪互联/{print $5*1000}' $logdir/zabbix_room_network.txt` -v sjhl_out=`awk '$2~/世纪互联/{print $6*1000}' $logdir/zabbix_room_network.txt`  '{if($2~/鲁谷/) {printf "%s\t%s\t%.2f\t%.2f\n",$1,$2,$5/lugu_in*100,$6/lugu_out*100} else if($2~/世纪互联/) {printf "%s\t%s\t%.2f\t%.2f\n",$1,$2,$5/lugu_in*100,$6/lugu_out*100}}' $logdir/zabbix_group_network_traffic.txt > $logdir/network_percent_avg.txt
##zabbix network max percent
awk -v lugu_in=`awk '$2~/鲁谷/{print $3*1000}' $logdir/zabbix_room_network.txt` -v lugu_out=`awk '$2~/鲁谷/{print $4*1000}' $logdir/zabbix_room_network.txt` -v sjhl_in=`awk '$2~/世纪互联/{print $3*1000}' $logdir/zabbix_room_network.txt` -v sjhl_out=`awk '$2~/世纪互联/{print $4*1000}' $logdir/zabbix_room_network.txt`  '{if($2~/鲁谷/) {printf "%s\t%s\t%.2f\t%.2f\n",$1,$2,$3/lugu_in*100,$4/lugu_out*100} else if($2~/世纪互联/) {printf "%s\t%s\t%.2f\t%.2f\n",$1,$2,$3/lugu_in*100,$4/lugu_out*100}}' $logdir/zabbix_group_network_traffic.txt > $logdir/network_percent_max.txt
##zabbix network min percent
awk -v lugu_in=`awk '$2~/鲁谷/{print $7*1000}' $logdir/zabbix_room_network.txt` -v lugu_out=`awk '$2~/鲁谷/{print $8*1000}' $logdir/zabbix_room_network.txt` -v sjhl_in=`awk '$2~/世纪互联/{print $7*1000}' $logdir/zabbix_room_network.txt` -v sjhl_out=`awk '$2~/世纪互联/{print $8*1000}' $logdir/zabbix_room_network.txt`  '{if($2~/鲁谷/) {printf "%s\t%s\t%.2f\t%.2f\n",$1,$2,$7/lugu_in*100,$8/lugu_out*100} else if($2~/世纪互联/) {printf "%s\t%s\t%.2f\t%.2f\n",$1,$2,$7/lugu_in*100,$8/lugu_out*100}}' $logdir/zabbix_group_network_traffic.txt > $logdir/network_percent_min.txt
#merge network percent max and avg
awk 'NR==FNR{a[$1,$2]=$3"\t"$4;next}{print $0,a[$1,$2]}' $logdir/network_percent_avg.txt  $logdir/network_percent_max.txt >$logdir/network_percent_max_and_avg.txt
#merge network percent max avg min
awk 'NR==FNR{a[$1,$2]=$3"\t"$4;next}{print $0,a[$1,$2]}' $logdir/network_percent_min.txt  $logdir/network_percent_max_and_avg.txt >$logdir/zabbix_network_percent.txt
sed -i '1i 日期\t所属组\t进入最大流量(单位:%)\t出去最大流量(单位:%)\t进入平均流量(单位:%)\t出去平均流量(单位:%)\t进入最小流量(单位:%)\t出去最小流量(单位:%)' $logdir/zabbix_network_percent.txt
rm -rf $logdir/network*.txt
