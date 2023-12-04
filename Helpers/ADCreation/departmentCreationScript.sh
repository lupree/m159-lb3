#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\e[0;34m'
NC='\033[0m'

groupCode=''

while getopts ":g:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "${RED}Invalid groupCode. It must be 2 characters long and not empty${NC}"
                exit
            fi;;
    esac
done

lowerGroupCode=$(echo $groupCode | tr '[:upper:]' '[:lower:]')
upperGroupCode=$(echo $groupCode | tr '[:lower:]' '[:upper:]')

departmentData="departments.csv"

echo -e "${BLUE}Lower: $lowerGroupCode${NC}"
echo -e "${BLUE}Upper: $upperGroupCode${NC}"


if [ ! -f "$departmentData" ]; then
    echo -e "${RED}Departments Data File not Found${NC}"
    exit 1
fi


while IFS=',' read -r displayName department
do
    if [ $department ]; then
        DN="OU=$lowerGroupCode$displayName,OU=$lowerGroupCode$department,DC=BIODESIGN$upperGroupCode,DC=LAN"
        echo $DN
        # samba-tool ou create $DN -Uadministrator
    else
        DN="OU=$lowerGroupCode$displayName,DC=BIODESIGN$upperGroupCode,DC=LAN"
        echo $DN
        # samba-tool ou create $DN -Uadministrator
    fi
done < "$departmentData"

echo -e "${GREEN}CSV Read successfully${NC}"