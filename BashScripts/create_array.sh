#!/bin/bash

#number of rows and columns
row_col=$(( $RANDOM % 10 + 3))

for (( i=0; i<$row_col; i++))
do
	for (( j=0; j<$row_col; j++))
	do
		rand_num=$(( 1 + $RANDOM % 9 ))
		echo -n "${rand_num} "
	done
	echo ""
done

