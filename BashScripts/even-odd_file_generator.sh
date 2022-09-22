#!/bin/bash

if [ $# -lt 2 ]
then
	echo "not all parameters"
fi

#dir - name of the generated folder
dir=$1
depth=$2

if [ "${depth}" -gt 10 ]
then
	depth=10
fi	

mkdir "${dir}"
cd "${dir}"

for (( i=1; i<=$depth; i++ ))
do
	rand_f=$(( $RANDOM % 10 + 1 ))

	for (( j=1; j<=$rand_f; j++ ))
	do
	 	: > "file${j}"
		if [ $((j % 2)) -eq 0 ]
		then
			echo "even" > "file${j}"
		else
			echo "odd" > "file${j}"
		fi
	done

	if [ "${i}" -lt "${depth}" ]
	then
		mkdir "depth$(( ${i} + 1 ))"
		cd "depth$(( ${i} + 1 ))"
	fi

done
