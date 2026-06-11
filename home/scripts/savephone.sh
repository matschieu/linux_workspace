#!/bin/bash

HOME_SRC=`echo ~`
PRF_FILE=$HOME_SRC'/.unison/phone.prf'
DATA_SRC="/media/$USER/Data"
DEST="/media/$USER/Data/Mathieu/Téléphone/Galaxy S21"
GVFS='/run/user/1000/gvfs/'

function append_phone_prf() {
	echo $1 >> $PRF_FILE;
}

cd $GVFS

ls | wc -l > /dev/null
if [[ $? -eq 0 ]]; then
	echo "No phone found"
	exit 1
fi

echo "BEFORE CONTINUING, AUTORISE THE COMPUTER TO READ THE PHONE MEMORY"
read

cd "`ls`"
cd "`ls`"

SRC="`pwd`"

echo "From $SRC to $DEST"

touch $PRF_FILE
cp -f $PRF_FILE ${PRF_FILE}.save
rm $PRF_FILE

append_phone_prf "# $PRF_FILE"
append_phone_prf "# Unison preferences file"
append_phone_prf "root = $SRC"
append_phone_prf "root = $DEST"
append_phone_prf "ignore = Path *-GA32*"
append_phone_prf "ignore = Path LOST.DIR"
append_phone_prf "ignore = Path Alarms"
append_phone_prf "ignore = Path Android"
append_phone_prf "ignore = Path Movies"
append_phone_prf "ignore = Path Music"
append_phone_prf "ignore = Path Notifications"
append_phone_prf "ignore = Path Ringtones"
append_phone_prf "ignore = Path Sauvegarde"
append_phone_prf "perms = 0"
append_phone_prf "times = true"

echo "Unison profile:"
cat $PRF_FILE

CMD="unison phone -force $SRC -auto"
echo "Running $CMD"
$CMD

