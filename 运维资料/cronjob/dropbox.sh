

DROPBOX_USER="jackxia5@gmail.com" 
DROPBOX_PASS="DROPBOX_PASS" #//Dropbox...
DROPBOX_DIR="/backups" #//Dropbox.......
BACKUP_SRC="/home/wwwroot /data" #//..........................
BACKUP_DST="/home/backup" #//............
MYSQL_SERVER="127.0.0.1" #//....MySQL
MYSQL_USER="root" #//..MySQL...
MYSQL_PASS="MYSQL_PASS" #//..MySQL...

#
# Stop editing here.
NOW=$(date +"%Y.%m.%d")
DESTFILE="$BACKUP_DST/$NOW.tgz"

#
# Upload a file to Dropbox.
# $1 = Source file
# $2 = Destination file.
function dropboxUpload
{
        #
        # Code based on DropBox Uploader 0.6 from http://www.andreafabrizi.it/?dropbox_uploader
        LOGIN_URL="https://www.dropbox.com/login"
        HOME_URL="https://www.dropbox.com/home"
        UPLOAD_URL="https://dl-web.dropbox.com/upload"
        COOKIE_FILE="/tmp/du_cookie_$RANDOM"
        RESPONSE_FILE="/tmp/du_resp_$RANDOM"

    UPLOAD_FILE=$1
    DEST_FOLDER=$2

        # Login
        echo -ne " > Logging in..."
        curl -s -i -c $COOKIE_FILE -o $RESPONSE_FILE --data "login_email=$DROPBOX_USER&login_password=$DROPBOX_PASS&t=$TOKEN" "$LOGIN_URL"
        grep "location: /home" $RESPONSE_FILE > /dev/null

        if [ $? -ne 0 ]; then
                echo -e " Failed!"
                rm -f "$COOKIE_FILE" "$RESPONSE_FILE"
                exit 1
        else
                echo -e " OK"
        fi

        # Load home page
        echo -ne " > Loading Home..."
        curl -s -i -b "$COOKIE_FILE" -o "$RESPONSE_FILE" "$HOME_URL"

        if [ $? -ne 0 ]; then
                echo -e " Failed!"
                rm -f "$COOKIE_FILE" "$RESPONSE_FILE"
                exit 1
        else
                echo -e " OK"
        fi

        # Get token
        TOKEN=$(cat "$RESPONSE_FILE" | tr -d '\n' | sed 's/.*<form action="https:\/\/dl-web.dropbox.com\/upload"[^>]*>\s*<input type="hidden" name="t" value="\([a-z 0-9]*\)".*/\1/')

        # Upload file
        echo -ne " > Uploading '$UPLOAD_FILE' to 'DROPBOX$DEST_FOLDER/'..."
    curl -s -i -b $COOKIE_FILE -o $RESPONSE_FILE -F "plain=yes" -F "dest=$DEST_FOLDER" -F "t=$TOKEN" -F "file=@$UPLOAD_FILE"  "$UPLOAD_URL"
    grep "HTTP/1.1 302 FOUND" "$RESPONSE_FILE" > /dev/null

    if [ $? -ne 0 ]; then
        echo -e " Failed!"
                rm -f "$COOKIE_FILE" "$RESPONSE_FILE"
        exit 1
    else
        echo -e " OK"
                rm -f "$COOKIE_FILE" "$RESPONSE_FILE"
    fi
}

# Backup files.
echo "Dumping databases..."
mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS --all-databases > "$NOW-Databases.sql"
echo "Packing files..."
tar czf "$DESTFILE" $BACKUP_SRC "$NOW-Databases.sql"

dropboxUpload "$DESTFILE" "$DROPBOX_DIR"

echo "Cleaning the backups..."
rm -f "$NOW-Databases.sql"
find $BACKUP_DST -mtime +31 -delete
