#!/bin/bash

if [ $# -lt 3 ]
then
	echo "Not all parameters"
	exit
else
	backup_directory=$1
	s3_bucket_name=$2
	limit=$3
	datetime=$(date +%Y-%m-%d-%H-%M-%S)
	tarname="backup${datetime}.tar"

	GREEN='\033[0;32m'
	RED='\033[0;31m'
	NC='\033[0m' # No Color
fi


#step 1
echo "------------------------------------------------------------------"
echo -e "Step 1: Creating a temporary folder"
mkdir ~/tmp-backup
echo -e "Step 1: ${GREEN}Done${NC}"


#step 2
echo -e "\n------------------------------------------------------------------"
echo -e "Step 2: Check backup directory"
if [ ! -d "${backup_directory}" ]
then
	echo "Directory ${backup_directory} does not exist."
	echo -e "Step 2: ${RED}failure${NC}"
	exit
fi
echo -e "Step 2: ${GREEN}Done${NC}"


#step 3
echo -e "\n------------------------------------------------------------------"
echo -e "Step 3: Creating AWS bucket\n"

check_aws_bucket=$(aws --profile=vlm s3 ls | grep -wo "${s3_bucket_name}")

if [ "${s3_bucket_name}" != "${check_aws_bucket}" ]
then
	echo "Creating s3 bucket"
	aws --profile=vlm s3 mb s3://"${s3_bucket_name}" --region us-east-1
else 
	echo "Bucket already exists"
fi

echo -e "\nStep 3: ${GREEN}Done${NC}"


#step 4
echo -e "\n------------------------------------------------------------------"
echo -e "Step 4: Creating an archive\n"

tar -cPvf "${tarname}" "${backup_directory}"
mv "${tarname}" ~/tmp-backup

echo -e "\nStep 4: ${GREEN}Done${NC}"


#step 5
echo -e "\n------------------------------------------------------------------"
echo -e "Step 5: Copying archive to S3\n"

aws --profile=vlm s3 cp ~/tmp-backup/"${tarname}" s3://"${s3_bucket_name}"

echo -e "\nStep 5: ${GREEN}Done${NC}"


#step 6
echo -e "\n------------------------------------------------------------------"
echo -e "Step 6: Deleting temp folder"

rm -r ~/tmp-backup

echo -e "Step 6: ${GREEN}Done${NC}"


#step 7
echo -e "\n------------------------------------------------------------------"
echo -e "Step 7: Deleting unnecessary backups\n"

backups_count=$(aws --profile=vlm s3 ls s3://"${s3_bucket_name}" | wc -l)

if [ "${backups_count}" -gt "${limit}" ]
then
	need_to_delete=$(( "${backups_count}" - "${limit}" ))
	echo -e "Need to delete: ${need_to_delete} backup(s)"

	for (( i=0; i<"${need_to_delete}"; i++ ))
	do
		file_to_delete=$(aws --profile=vlm s3 ls s3://"${s3_bucket_name}" | sort | head -n 1 | awk '{print $4}')
		echo -e "\n${file_to_delete}"
		aws --profile=vlm s3 rm s3://"${s3_bucket_name}"/"${file_to_delete}"	
	done
fi
echo -e "\nStep 7: ${GREEN}Done${NC}"
