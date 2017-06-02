#!/bin/bash 
# Script to fetch nginx statuses for tribily monitoring systems 
# License: GPLv4 
# Set Variables 
BKUP_DATE=`/bin/date +%Y%m%d` 
LOG="/etc/zabbix/nginx_status.log" 
#HOST=`/sbin/ifconfig eth0 | sed -n '/inet /{s/.*addr://;s/ .*//;p}'` 
#HOST=`/sbin/ifconfig eth0 |grep "inet addr" |awk -F[:" "] '{print $13}'` 
#PORT="80" 
URL="http://127.0.0.1:80/nginx_status"
 
# Functions to return nginx stats 
function active { 
    /usr/bin/curl $URL 2>/dev/null| grep 'Active' | awk '{print $NF}'       
    }     
function reading { 
    /usr/bin/curl $URL 2>/dev/null| grep 'Reading' | awk '{print $2}'       
    }     
function writing { 
    /usr/bin/curl $URL 2>/dev/null| grep 'Writing' | awk '{print $4}'       
    }     
function waiting { 
    /usr/bin/curl $URL 2>/dev/null| grep 'Waiting' | awk '{print $6}'       
    }     
function accepts { 
    /usr/bin/curl $URL 2>/dev/null| awk NR==3 | awk '{print $1}' 
    }     
function handled { 
    /usr/bin/curl $URL 2>/dev/null| awk NR==3 | awk '{print $2}' 
    }       
function requests { 
    /usr/bin/curl $URL 2>/dev/null| awk NR==3 | awk '{print $3}' 
    } 

if [ $1 = "active" ];then
	active;
elif [ $1 = "reading" ];then
	reading;
elif [ $1 = "writing" ];then
	writing;
elif [ $1 = "waiting" ];then
	waiting;
elif [ $1 = "accepts" ];then
	accepts;
elif [ $1 = "handled" ];then
	handled;
elif [ $1 = "requests" ];then
	requests;
fi
