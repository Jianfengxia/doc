#!/bin/bash
# ******************************************************
# Author       : jun.li3
# Last modified: 2017-2-15 by 
# Email        : jun.li3@fe.com
# Filename     : autobak.sh
# Version      : v1.1
# Description  : backup db by mysqldump
# ******************************************************
DB_USER="root"
DB_PASS="jishu8cc"

# Others vars
BIN_DIR="/usr/local/mysql/bin"
BCK_DIR="/data/mysqlbak"
DATE=`date +%F`

# TODO
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  edu_center | gzip > $BCK_DIR/edu_center_$DATE.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  jczt_luhao | gzip > $BCK_DIR/jczt_luhao_$DATE.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  edu_center_jcjyzt | gzip > $BCK_DIR/edu_center_jcjyzt_$DATE.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  edu_center_jrzt | gzip > $BCK_DIR/edu_center_jrzt_$DATE.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  edu_center_qczt | gzip > $BCK_DIR/edu_center_qczt_$DATE.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  edu_center_yjzt | gzip > $BCK_DIR/edu_center_yjzt_$DATE.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  edu_center_zyhxzt | gzip > $BCK_DIR/edu_center_zyhxzt_$DATE.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  edu_center_base | gzip > $BCK_DIR/edu_center_base_$DATE.gz
$BIN_DIR/mysqldump -u$DB_USER -p$DB_PASS --quick  --single-transaction -R  test | gzip > $BCK_DIR/test_$DATE.gz

find $BCK_DIR -name "*.gz" -mtime +15 -exec rm -f {} \;
