#!/bin/bash

# Useful documentation about Unison:
# https://karlesnine.developpez.com/unison/
# https://doc.ubuntu-fr.org/unison

UNISON_DIR='/home/mathieu/.unison/'
HDD_DIR='/media/mathieu/WD_Elements/Thinkpad T470/unison/'

HOME_IGNORE_PATH='{.*};{.config/*};{.snap/*};{snap}'
HOME_IGNORE_NAME='{.*};{*~};{.*~};{target/*};{node_modules/*}'
HOME_IGNORE_NOT_NAME='{.bash*}'
HOME_IGNORE_NOT_PATH='{.config};{.icons};{.config/chromium};.vimrc;.mozilla;.m2'
HOME_SRC='/home/mathieu'
HOME_DEST=$HDD_DIR'home'

DATA_IGNORE_PATH='{$RECYCLE.BIN};System Volume Information'
DATA_IGNORE_NAME='{.*~}'
DATA_IGNORE_NOT_NAME=''
DATA_IGNORE_NOT_PATH=''
DATA_SRC='/media/mathieu/Data'
DATA_DEST=$HDD_DIR'data'

OPT_IGNORE_PATH=''
OPT_IGNORE_NAME='{*~};{.*~}'
OPT_IGNORE_NOT_NAME=''
OPT_IGNORE_NOT_PATH=''
OPT_SRC='/opt'
OPT_DEST=$HDD_DIR'opt'

function get_unison_cmd() {
	CMD="unison $1"

	if ! [[ -z "$FORCE" ]]; then
		CMD="$CMD -force $2"
	fi

	if ! [[ -z "$AUTO" ]]; then
		CMD="$CMD -auto"
	fi

	echo "$CMD"
}

function profile_append() {
	echo $2 >> $1;
}

function init_profile() {
	PROFILE_FILE="$UNISON_DIR$1.prf"
	SRC=$2
	DEST=$3
	IGNORE_PATH=$4
	IGNORE_NAME=$5
	IGNORE_NOT_NAME=$6
	IGNORE_NOT_PATH=$7

	touch $PROFILE_FILE
	cp -f $PROFILE_FILE ${PROFILE_FILE}.save
	rm $PROFILE_FILE
	
	profile_append $PROFILE_FILE "# $PROFILE_FILE"
	profile_append $PROFILE_FILE "# Unison preferences file"
	profile_append $PROFILE_FILE ""
	profile_append $PROFILE_FILE "root = $SRC"
	profile_append $PROFILE_FILE "root = $DEST"
	profile_append $PROFILE_FILE ""

	# Disable the wildcard intepretation
	set -f
	# Change the internal field separator to use ;
	IFS_SAVE=$IFS
	IFS=";"

	for i in $IGNORE_PATH; do
		profile_append $PROFILE_FILE "ignore = Path $i"
	done

	profile_append $PROFILE_FILE ""

	for i in $IGNORE_NAME; do
		profile_append $PROFILE_FILE "ignore = Name $i"
	done;

	profile_append $PROFILE_FILE ""

	for i in $IGNORE_NOT_NAME; do
		profile_append $PROFILE_FILE "ignorenot = Name $i"
	done;

	profile_append $PROFILE_FILE ""

	for i in $IGNORE_NOT_PATH; do
		profile_append $PROFILE_FILE "ignorenot = Path $i"
	done;
	
	# Restore system changes
	IFS=$IFS_SAVE
	set +f

	profile_append $PROFILE_FILE ""
	#fat = true
	#links = true
	#ignorecase = false
	profile_append $PROFILE_FILE "perms = 0"
	profile_append $PROFILE_FILE "times = true"

	cat $PROFILE_FILE
	echo
}

function save() {
	PROFILE=$1
	SRC=$2
	DEST=$3

	echo "Saving $SRC into $DEST"
	CMD=$(get_unison_cmd $PROFILE $SRC)
	echo $CMD
	$CMD
}

# HELP

function usage() {
	echo "Syntax: "basename $0 [options]
	echo ""
	echo "Where options are:"
	echo -e "\t-h: save $HOME_SRC into $HOME_DEST"
	echo -e "\t-o: save $OPT_SRC into $OPT_DEST"
	echo -e "\t-d: save $DATA_SRC into $DATA_DEST"
	echo -e "\t-f: use the force mode to synchronise in one direction from the local computer to the save volume"
	echo -e "\t-a: use the auto mode to accept all the differences automatically"
	echo -e "\t-?: display help"
}

# MAIN

while getopts "afhod?" option
do
	case $option in
		a)
			AUTO=true
			;;
		f)
			FORCE=true
			;;
		h)
			SAVE_HOME=true
			;;
		o)
			SAVE_OPT=true
			;;
		d)
			SAVE_DATA=true
			;;
		?)
			usage
			;;
	esac
done

if [ "$SAVE_HOME" = true ]; then
	init_profile "home" "$HOME_SRC" "$HOME_DEST" "$HOME_IGNORE_PATH" "$HOME_IGNORE_NAME" "$HOME_IGNORE_NOT_NAME" "$HOME_IGNORE_NOT_PATH"
	save "home" "$HOME_SRC" "$HOME_DEST"
fi

if [ "$SAVE_OPT" = true ]; then
	init_profile "opt" "$OPT_SRC" "$OPT_DEST" "$OPT_IGNORE_PATH" "$OPT_IGNORE_NAME" "$OPT_IGNORE_NOT_NAME" "$OPT_IGNORE_NOT_PATH"
	save "opt" "$OPT_SRC" "$OPT_DEST"
fi

if [ "$SAVE_DATA" = true ]; then
	init_profile "data" "$DATA_SRC" "$DATA_DEST" "$DATA_IGNORE_PATH" "$DATA_IGNORE_NAME" "$DATA_IGNORE_NOT_NAME" "$DATA_IGNORE_NOT_PATH"
	save "data" "$DATA_SRC" "$DATA_DEST"
fi

