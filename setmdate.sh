#!/bin/bash

# PROBLEM: if you want to change "Change" time, you have to change system time before running this script

# ********************************************************************************
# Parameters
# ********************************************************************************

# Reference date
if [ -z "$1" ]; then
	MAXDATE=$(date -d "yesterday" '+%m/%d/%Y')
else
	MAXDATE=$(date -d $1 '+%m/%d/%Y')
fi

# Root directory
if [ -z "$2" ]; then 
	ROOT='.'
else 
	ROOT=$2
fi

# Pattern of filenames
if [ -z "$3" ]; then 
	FILENAMEPATTERN='*'
else 
	FILENAMEPATTERN=$3
fi

echo "Max date = $MAXDATE; Root directory = $ROOT; file pattern = $FILENAMEPATTERN"

# ********************************************************************************
# Replacement
# ********************************************************************************

# Going through files (except "this" folder and this sh-file)
for f in $(find "$ROOT" -name "$FILENAMEPATTERN" -not -name '.' -not -name "$0"); do
	# Show filename for testing purposes
	# echo $f

	# Times of last access and last modification — hh:mm:ss.ns
	atime=$(stat -c%x "$f" | cut -c12-29)	# last access
	mtime=$(stat -c%y "$f" | cut -c12-29)	# last modification

	# VALUES FOR DATE COMPARISON
	# Reference
	reference=$(date -d $MAXDATE +%s)
	# Date of last access
	access=$(date -d "$(stat -c%x "$f" | cut -c1-10)" +%s)
	# Date of last modification
	modify=$(date -d "$(stat -c%y "$f" | cut -c1-10)" +%s)

	# New access date, -a flag
	if [ $access -gt $reference ]; then
		touch -a --date "$MAXDATE $atime" "$f"
		echo "$f — new access timestamp: $MAXDATE $atime"
	fi
	
	# New modify date, -m flag 
	if [ $modify -gt $reference ]; then
		touch -m --date "$MAXDATE $mtime" "$f"
		echo "$f — new modify timestamp: $MAXDATE $mtime"
	fi
done

