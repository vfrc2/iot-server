#!/bin/bash

NAME=$1

if [ -z "$SERVER_BACKUP_DIR" ]; then
    echo "SERVER_BACKUP_DIR env not set"
    exit 1
fi

BACKUP_DIR=${SERVER_BACKUP_DIR}/$NAME

docker run -v ${BACKUP_DIR}:/backup --volumes-from $NAME \
  -it --rm alpine