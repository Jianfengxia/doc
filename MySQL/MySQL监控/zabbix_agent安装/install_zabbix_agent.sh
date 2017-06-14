#!/bin/bash
# ******************************************************
# Author       : Fander.Chan
# Last modified: 2016-12-19 09:55
# Email        : 
# Filename     : install_zabbix_agent.sh
# Description  : Test in CentOS6.5
# ******************************************************

# Variable
ZABBIX_SERVER=10.228.3.70,10.1.134.220
ZABBIX_AGENT=`ifconfig  | sed -n '2p' | sed 's#^.*addr:##g' | sed 's#  Bc.*$##g'`
ZABBIX_AGENT_CONF=/etc/zabbix/zabbix_agentd.conf

# Check if user is root
if [ "0" != "`id -u`" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi

# Check if installed or not
CHECK_INSTALLED=`chkconfig --list | grep zabbix | grep zabbix-agent`
[ -n "${CHECK_INSTALLED}" ] && echo -e "\033[31m ERROR! zabbix-agent is already installed \033[0m" && exit 1

# Downdown zabbix-agent & install
rpm -ivh  http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm
yum install -y zabbix-agent

[ -f "${ZABBIX_AGENT_CONF}" ] && sed -i "s/127.0.0.1/${ZABBIX_SERVER}/g" "${ZABBIX_AGENT_CONF}" || {
echo -e "\033[31m ERROR! ${ZABBIX_AGENT_CONF} is not exist \033[0m"
exit 1 
}
[ -f "${ZABBIX_AGENT_CONF}" ] && sed -i "s/Hostname=Zabbix server/Hostname=${ZABBIX_AGENT}/g" "${ZABBIX_AGENT_CONF}" || {
echo -e "\033[31m ERROR! ${ZABBIX_AGENT_CONF} is not exist \033[0m"
exit 1 
}

#setup auto start
chkconfig zabbix-agent on
service zabbix-agent start


echo -e "\033[32m Finish install \033[0m" && exit 0

