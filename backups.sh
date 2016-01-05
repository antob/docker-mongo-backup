#!/bin/bash

source /mongodb_env.sh

MYDATE=`date +%Y-%m-%d`
MONTH=$(date +%m)
YEAR=$(date +%Y)
MYBASEDIR=/backups
MYBACKUPDIR=${MYBASEDIR}/${YEAR}/${MONTH}
mkdir -p ${MYBACKUPDIR}
cd ${MYBACKUPDIR}

echo "[MONGO_BACKUP] Backup running to $MYBACKUPDIR" >> /var/log/cron.log
echo "[MONGO_BACKUP] Backing up DB $MONGODB_DATABASE on host $MONGODB_HOST"  >> /var/log/cron.log

mongodump -h $MONGODB_HOST -d $MONGODB_DATABASE

if [ $? -ne 0 ]; then
  echo "[MONGO_BACKUP] Error: Failed to backup $MONGODB_DATABASE" >> /var/log/cron.log
  exit 0
fi

FILENAME=${MYBACKUPDIR}/${MONGODB_DATABASE}.${MYDATE}.dump.tgz
tar -zcvf $FILENAME dump
rm -rf dump
