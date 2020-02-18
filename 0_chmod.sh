#!/bin/sh
START_DIR=`/usr/bin/dirname $0`
. $START_DIR/config
if ! [ "$BACKUP_DIR" ]
then
	echo "config not found"; exit 1;
fi

find $BACKUP_DIR -type f -mtime -10 \
\( -name "*.7z" \
-or -name "*.rar" \
-or -name "*.zip" \
-or -name "*.bz2" \
-or -name "*.bak" \
-or -name "*.log" \
-or -name "*.data" \
-or -name "asued*" \
-or -name "iap*" \
-or -name "*.dmp" \) \
-exec chmod 640 {} \;

chmod +r ${BACKUP_DIR}/kvasy/archive/*
