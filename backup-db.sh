#!/bin/bash
USER="root"
PASS=''
DATEMOD=$(date +"%Y-%M-%d_%H%M%S")
DBNAME="goshowag_ags"
HOST="localhost"
SERVER_NAME="ags-show"
BKPDIR="/usr/local/bin/backup-db/$SERVER_NAME"
FILENAME="backup-$DBNAME-$DATEMOD"
BUCKET_NAME="yaregroup-backup-dbs"

##############################
echo "## CREATING BACKUP $FILENAME ##"
mkdir -p $BKPDIR
mysqldump -u$USER -p$PASS -h$HOST $DBNAME > $BKPDIR/$FILENAME
tar -czvf $BKPDIR/$FILENAME.tgz $BKPDIR/$FILENAME
rm -fr $BKPDIR/$FILENAME

echo "Uploading Backup to S3"
echo "aws s3 sync $BKPDIR s3://$BUCKET_NAME/$SERVER_NAME"
aws s3 sync $BKPDIR s3://$BUCKET_NAME/$SERVER_NAME

