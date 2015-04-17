#!/bin/bash

#
# Copyright (c) 2009-2015. Authors: see NOTICE file.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

echo "The backup path is $BACKUP_PATH"

mkdir -p /var/cytomine/
if [ "$SGBD" == "postgres" ] 
then
	cp /tmp/script_backup_postgres.sh /var/cytomine/script_backup.sh
	rm /tmp/script_backup_mongo.sh
	rm /tmp/mongodump
	rm /tmp/mongorestore
fi
if [ "$SGBD" == "mongodb" ] 
then
	cp /tmp/script_backup_mongo.sh /var/cytomine/script_backup.sh
	cp /tmp/mongodump /usr/bin/mongodump
	cp /tmp/mongorestore /usr/bin/mongorestore
	rm /tmp/script_backup_postgres.sh
fi
chmod +x /var/cytomine/script_backup.sh

echo "mailhub=$SENDER_EMAIL_SMTP_HOST:$SENDER_EMAIL_SMTP_PORT" >> /etc/ssmtp/ssmtp.conf
echo "AuthUser=$SENDER_EMAIL" >> /etc/ssmtp/ssmtp.conf
echo "AuthPass=$SENDER_EMAIL_PASS" >> /etc/ssmtp/ssmtp.conf

#hostname:port:database:username:password
echo "db:*:$DATABASE:$USER:$PASSWD" > /root/.pgpass
chmod 600 /root/.pgpass

echo "Add the backup script to crontab"
# Add to crontab

echo "#Setting env var" >> /tmp/crontab

if [ "$SGBD" == "postgres" ] 
then
	echo "DATABASE=$DATABASE" >> /tmp/crontab
	echo "USER=$USER" >> /tmp/crontab
fi

echo "CONTAINER=db" >> /tmp/crontab
echo "#End setting env var" >> /tmp/crontab

echo "30 23 * * * /var/cytomine/script_backup.sh $BACKUP_PATH $RECEIVER_EMAIL" >> /tmp/crontab
#echo "* * * * * /var/cytomine/script_backup.sh $BACKUP_PATH $RECEIVER_EMAIL" >> /tmp/crontab
crontab /tmp/crontab
rm /tmp/crontab

echo "run cron"
cron
tail -f /root/.pgpass


