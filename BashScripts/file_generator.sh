#!/bin/bash

if [ $# -lt 2 ]
then
	echo "not all parameters"
fi

dir=$1
depth=$2

if [ "${depth}" -gt 10 ]
then
	depth=10
fi	

rand=$(( $RANDOM % 10 + 1))

mkdir "${dir}"
cd "${dir}"

for (( i=1; i<=$depth; i++ ))
do
	rand_f=$(( $RANDOM % 10 + 1 ))
	rand_d=$(( $RANDOM % 10 + 1 ))

	for (( j=1; j<=$rand_f; j++ ))
	do
		: > "file${j}"
	done

	for (( j=1; j<=$rand_d; j++ ))
	do
		mkdir "dir${j}"
	done

	if [ "${i}" -lt "${depth}" ]
	then
		mkdir "depth$(( ${i} + 1 ))"
		cd "depth$(( ${i} + 1 ))"
	fi

done

