#!/bin/bash

# MySQL container details
CONTAINER_NAME="xxx"
MYSQL_ROOT_PASSWORD="xxx"

# Remote server details
REMOTE_SERVER="10.10.0.1"
REMOTE_USER="bk-user"
#REMOTE_PASSWORD="your_remote_password"
REMOTE_DIRECTORY="/home/bk-dir/backup/"

# Backup directory
today=`date +%m-%d-%Y`
BACKUP_DIRECTORY="/var/lib/mysql/backups/bk-$today"

# Create the backup directory if it doesn't exist
mkdir -p "$BACKUP_DIRECTORY/"

# Get a list of all databases
DATABASES=$(docker exec "$CONTAINER_NAME" mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

# Loop through each database and export a backup
for DATABASE in $DATABASES; do
  BACKUP_FILE="$BACKUP_DIRECTORY/$DATABASE.sql"
  docker exec "$CONTAINER_NAME" mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" "$DATABASE"|gzip > "$BACKUP_FILE.gz"
done

# Transfer the backups to the remote server
#rsync -avz -e  "$BACKUP_DIRECTORY" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIRECTORY"
scp -r "$BACKUP_DIRECTORY" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIRECTORY"

# Cleanup: Remove local backups older than 7 days
find  /var/lib/mysql/backups/  -type d -name "bk-*" -mtime +4 -exec rm -rf {} +
