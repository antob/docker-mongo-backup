#!/bin/bash

# Source mounted secrets if available
if [ -f /etc/secrets/env ]; then
  . /etc/secrets/env
fi

# Check if each var is declared and if not,
# set a sensible default
if [ -z "${MONGODB_URL}" ]; then
  MONGODB_URL=mongodb://localhost:27017/app
fi

# Parse DB URL
# extract the protocol
proto="$(echo $MONGODB_URL | grep :// | sed -e's,^\(.*://\).*,\1,g')"
# remove the protocol
url="$(echo ${MONGODB_URL/$proto/})"
# extract the user (if any)
user="$(echo $url | grep @ | cut -d@ -f1)"
# extract the host
host="$(echo ${url/$user@/} | cut -d/ -f1)"
# extract the DB name
database="$(echo $url | grep / | cut -d/ -f2-)"

if [ -z "${MONGODB_HOST}" ]; then
  MONGODB_HOST=$host
fi

if [ -z "${MONGODB_DATABASE}" ]; then
  MONGODB_DATABASE=$database
fi

# Now write these all to case file that can be sourced
# by then cron job - we need to do this because
# env vars passed to docker will not be available
# in the contenxt of then running cron script.

echo "
export MONGODB_HOST=$MONGODB_HOST
export MONGODB_DATABASE=$MONGODB_DATABASE
 " > /mongodb_env.sh

echo "[MONGO_BACKUP] Starting backup script."

# Now launch cron and rsyslogd. Tail logs in the foreground
rsyslogd && cron && tail -fq /var/log/syslog /var/log/cron.log
