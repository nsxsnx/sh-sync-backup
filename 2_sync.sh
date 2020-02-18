#!/bin/sh
START_DIR=`/usr/bin/dirname $0`
. $START_DIR/config
if ! [ "$FTP_HOST" -a "$FTP_USER" -a "$FTP_PASS" -a "$SYNC_LOCALDIR" -a "$SYNC_REMOTEDIR" ]
then
	echo "config not found"; exit 1;
fi

if ! [ "$(ls -A $SYNC_LOCALDIR)" ]
then
    echo "$SYNC_LOCALDIR is empty!"; exit 1;
fi

/usr/bin/lftp -c "open ftp://$FTP_USER:$FTP_PASS@$FTP_HOST; 
lcd $SYNC_LOCALDIR;
cd $SYNC_REMOTEDIR;
mirror --reverse \
       --delete-first \
       --verbose \
       --dereference \
       --exclude-glob */.ssh/ \
       --exclude-glob */.mc/ \
       --exclude-glob */.bashrc \
       --exclude-glob */.bash_logout \
       --exclude-glob */.profile \
       --continue;
bye;"
       #--only-newer;
       #--dry-run \
exit;
