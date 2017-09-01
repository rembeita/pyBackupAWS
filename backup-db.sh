#!/bin/bash
USER="root"
PASS='ADjoft#$qewfod@'
DATEMOD=$(date +"%Y-%m-%d_%H%M%S")
DBNAME="goshowag_ags"
HOST="localhost"
SERVER_NAME="ags-show"
BKPDIR="/usr/local/bin/backup-db/$SERVER_NAME"
FILENAME="backup-$DBNAME-$DATEMOD"
BUCKET_NAME="yaregroup-backup-dbs"
OLDER_THAN="5"
##############################
echo "## CREATING BACKUP $FILENAME ##"
echo "Creating DIR $BKPDIR"
mkdir -p $BKPDIR
mysqldump -u$USER -p$PASS -h$HOST $DBNAME > $BKPDIR/$FILENAME
echo "Compressing tar -czvf $BKPDIR/$FILENAME.tgz $BKPDIR/$FILENAME"
tar -czvf $BKPDIR/$FILENAME.tgz $BKPDIR/$FILENAME
echo "Deleting rm -fr $BKPDIR/$FILENAME"
rm -fr $BKPDIR/$FILENAME

echo "Uploading Backup to S3"
echo "aws s3 sync $BKPDIR s3://$BUCKET_NAME/$SERVER_NAME"
export AWS_ACCESS_KEY_ID=AKIAJH32UVV7774NIWIA
export AWS_SECRET_ACCESS_KEY=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
aws s3 sync $BKPDIR s3://$BUCKET_NAME/$SERVER_NAME
echo "Deleting older backups"

find $BKPDIR -mtime +$OLDER_THAN -exec rm {} \;
