#!/bin/bash

if [ $# -gt 3 ]
then
	echo "not all parameters"
else
	backup=$1
	backupDir=$2
	limit=$3
	datetime=$(date +%Y%m%d%H%M%S)
	tarname="backup${datetime}.tar"
fi

#create archive
tar -cPvf "${tarname}" "${backup}"
#move archive
mv "${tarname}" "${backupDir}"
#number of backups
count=$(ls "${backupDir}" | grep ".tar" | wc -l)

if [ "${count}" -gt "${limit}" ]
then
	ls -t "${backupDir}" | tail -n "$(( "${count}" - "${limit}" ))" | ( cd "${backupDir}" && xargs -d '\n' rm )	
fi
