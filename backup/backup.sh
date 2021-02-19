#!/bin/sh

# Fullbackup every day, l
# ex backup.sh test backup list
NAME=$1
shift 1
BACKUP_LIST="$@"

if [ -z "$SERVER_BACKUP_DIR" ]; then
    echo "SERVER_BACKUP_DIR env not set"
    exit 1
fi

BACKUP_DIR=${SERVER_BACKUP_DIR}/$NAME

KEY=$(date +%Y)$(date +%V)
DATE=$(date --iso)
BACKUP_NAME=${KEY}-${DATE}-${NAME}

docker stop $NAME # stop container

if [ $? -ne 0 ]; then
    echo "Error stoping container"
    exit 2
fi

docker run -v ${BACKUP_DIR}:/backup --volumes-from $NAME \
  --rm alpine \
  tar cfvz /backup/${BACKUP_NAME}.tar.gz $BACKUP_LIST

if [ $? -ne 0 ]
then
    echo "Error to backup container"
else
    echo "Skip remote copy"
    #rsync -a $BACKUP_DIR backup@backupserver.example.com:/backup/$NAME
fi

docker start $NAME

# cleanup files older then 7 days
find $BACKUP_DIR -type f -mtime +7 -name '*.gz' -execdir rm -- '{}' \;
