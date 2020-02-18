#!/bin/sh
START_DIR=`/usr/bin/dirname $0`
. $START_DIR/config
if ! [ "$LIST_FILE" -a "$BACKUP_DIR" -a "$TMP_DIR" ]
then
	echo "configuration not found or malformed"; exit 1;
fi

die()
{
	exit 1;
}

makedir()
{
	NEW_DIR=$1
	if ! [ -d $NEW_DIR ] 
	then
		echo "Creating directory \"$NEW_DIR\"..."
		mkdir -p $NEW_DIR
		if [ $? -gt 0 ]
		then
			err "can't create directory \"%s\"" $NEW_DIR
			die
		fi
	fi
}

err()
{
	printf "\033[31m$1\033[0m\n" $2
}

warn()
{
	printf "\033[33m$1\033[0m\n" $2
}

makedir $TMP_DIR
echo "Cleaning temporary directory \"$TMP_DIR\""
rm -r $TMP_DIR/*
cat $LIST_FILE | while read STR
do
	cd $TMP_DIR
	STR=`echo "$STR" | sed "s/#.*//g" | sed "s/\t/ /g"`
	if [ -z `echo "$STR" | sed "s/ //g"` ]; then continue; fi;
	DIR=`echo "$STR" | awk '{print $1}'`
	FILE=`echo "$STR" | awk '{print $2}'`
	DEPTH=`echo "$STR" | awk '{print $3}'`
	echo
	if ! [ "$DIR" -a "$FILE" -a "$DEPTH" ]
	then 
		warn "Malformed string in resourse file: \"%s\", skipping" $STR
		continue
	fi
	echo "Working on \"\033[1m$DIR\033[0m\" with mask \"\033[1m$FILE\033[0m\" and depth \"\033[1m$DEPTH\033[0m\"..."
	if [ ! -d $BACKUP_DIR/$DIR ]
	then
		warn "Directory \"%s\" doesn't exist, skipping" $BACKUP_DIR/$DIR
		continue
	fi
	if ! [ $DEPTH -ge 0 -a $DEPTH -le 9999 2>/dev/null ] 
	then
		warn "Incorrect value for depth: \"%s\", skipping" $DEPTH
		continue
	fi
	makedir $TMP_DIR/$DIR
	cd $TMP_DIR/$DIR
	echo "Populating \"$DIR\":"
	find $BACKUP_DIR/$DIR -type f -mtime -$DEPTH -name "$FILE" | sort | while read FILE_NAME
	do
		LINK=`basename "$FILE_NAME" | sed "s/ /_/g"`
 		if [ -e "$LINK" ]
 		then
 			warn "   %s already exists, leaving as is" $LINK
 			continue
 		fi
		echo "   $LINK"
		ln -s "$FILE_NAME" "$LINK"
	done
done

