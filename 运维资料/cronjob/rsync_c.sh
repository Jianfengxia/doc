#vim /etc/rsyncd.scrt -- xiajie


rsync -avz --password-file=/etc/rsyncd.scrt wwyhy@www.xxx.com::xxxbackup /root/backup
rsync -avz --password-file=/etc/rsyncd.scrt wwyhy@www.xxx.com::xxxwww /home/wwwroot/www.xxx.com/
#rsync -avz --password-file=/etc/rsyncd.scrt wwyhy@www.xxx.com::xxxdb /root/backup/db
