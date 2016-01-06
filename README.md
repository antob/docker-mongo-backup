# Docker MongoDB Backup


A simple docker container that runs MongoDB backups.

To restore a backup, attach to the running mongo-backup container:

$ kubectl exec mongodb-2ixq3 -c mongo-backup bash
$ source /mongodb_env.sh
$ cd /backups/2015/12
$ tar xvf app.2015-12-13.dump.tgz
$ mongorestore -h mongodb:27017 -d app /backups/2015/12/dump/app --drop
