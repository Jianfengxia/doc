#!/bin/bash
#Write by jackxia5@gmail.com

DBHOST=xxxxx.aliyuncs.com
USERNAME=USERNAME
PASSWORD=PASSWORD
DBNAMES="DBNAMES"
CREATE_DATABASE="yes"
BACKUPDIR="/root/xxxdb"
MAILADDR="xxx@xx.com"
MAILMAXATTSIZE="2000000"

DATE=`date +%Y-%m-%d_%H_%M`
OPT="--quote-names --opt"

if [ ! -e "${BACKUPDIR}" ]; then
   mkdir -p "${BACKUPDIR}"
fi

#rm -fv ${BACKUPDIR}/*

if [ "${CREATE_DATABASE}" = "yes" ]; then
   OPT="${OPT} --databases"
else
   OPT="${OPT} --no-create-db"
fi

if [ "${DBNAMES}" = "all" ]; then
   DBNAMES="--all-databases"
fi

BACKUPFILE=${DATE}.sql.gz

cd ${BACKUPDIR}

`which mysqldump` --user=${USERNAME} --password=${PASSWORD} --host=${DBHOST} ${OPT} ${DBNAMES} |gzip > "${BACKUPFILE}"

BACKFILESIZE=`du -b ${BACKUPFILE}|sed -e "s/\t.*$//"`

if [ ${BACKFILESIZE} -ge ${MAILMAXATTSIZE} ]; then
   `which split` -b ${MAILMAXATTSIZE} ${BACKUPFILE} ${BACKUPFILE}.
   for BFILE in ${BACKUPFILE}.*
   do
       echo "Backup Databases: ${DBNAMES}; Use cat ${BACKUPFILE}.* > ${BACKUPFILE}" | mutt ${MAILADDR} -s "MySQL Backup SQL Files for ${HOST} - ${DATE}" -a "${BFILE}"
   done
else
   echo "Backup Databases: ${DBNAMES}" | mutt ${MAILADDR} -s "MySQL Backup SQL Files for ${HOST} - ${DATE}" -a "${BACKUPFILE}" 
fi

