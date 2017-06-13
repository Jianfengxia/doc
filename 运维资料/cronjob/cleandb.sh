#!/bin/sh

mysql_host="mysql_host"
mysql_user="mysql_user"
mysql_passwd="mysql_passwd"
DB_name="DB_name"

/usr/bin/mysql -u${mysql_user} -h${mysql_host} -p${mysql_passwd} -e "use ${DB_name};truncate adminlogger_log;truncate dataflow_batch_export;truncate dataflow_batch_import;truncate log_customer;truncate log_quote;truncate log_summary;truncate log_summary_type;truncate log_url;truncate log_url_info;truncate log_visitor;truncate log_visitor_info;truncate log_visitor_online;truncate report_viewed_product_index;truncate report_compared_product_index;truncate report_event;set foreign_key_checks = 0;truncate index_process_event;truncate index_event;set foreign_key_checks = 1;"
