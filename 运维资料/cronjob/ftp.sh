
host="host"            # ....
id="id"                       # ..... FTP ..
pw='pw'                     # ......
basedir="/root/backup"          # ...........
remotedir="/backup"             # .........

# ===========================================
backupfile="cc.201307240214.sql.gz"
cd $basedir
#  tar -jpc -f $backupfile $(basename $basedir)

ftp -n "$host" <<EOF
user $id $pw
binary
cd $remotedir
put $backupfile
bye
EOF

