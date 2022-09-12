#!/bin/bash

curr_user=$(whoami)

echo -e "_________________________________\n"
echo -e "Processes: \n"
ps -fu "${curr_user}"

echo -e "_________________________________\n"
echo -e "CPU Usage: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"% \n"

free_memory=$(free --mega | awk '{print $4}' | awk '(NR==2)')
free_swap=$(free --mega | awk '{print $4}' | awk '(NR==3)')

echo -e "_________________________________\n"
echo -e "Free memory(+swap): ${free_memory}(+${free_swap}) Mb \n"

echo -e "_________________________________\n"
if [ $# -eq 0 ]
then
	echo "Ports (all): "
	netstat -ant
else
	echo "Ports ($1): "
	netstat -ant | grep ":$1"
fi

echo -e "\n_________________________________\n"
echo -e "All disk space:"
d_count=$(lsblk | awk '{print $4}' | wc -l)
all_disk_space=0
for (( i = 2; i <=$d_count; i++ ))
do
	d_size=$(lsblk | awk '{print $4}' | awk '(NR=='${i}')' | tr -d 'a-zA-Z')
	all_disk_space=$(( "${all_disk_space}" + "${d_size}" ))
done
echo "${all_disk_space}G"




