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

shareData='gl
hr
verkauf
einkauf
finanzen
kundendienst
werkstatt
public'

echo -e "${BLUE}    FS  | $currentIP: ${YELLOW}Creating Shares${NC}"

rootShareName="${upperGroupCode}Share"
rootSharePath="/$rootShareName"

mkdir -m 775 $rootSharePath
chgrp "BIODESIGN$upperGroupCode\Domain Admins" $rootSharePath

net conf addshare $rootShareName $rootSharePath writeable=y guest_ok=n "$rootShareName"
net conf setparm $rootShareName "browsable" "yes"

echo "$shareData" | while IFS=',' read -r shareName
do
    sharePath="/${upperGroupCode}Share/${upperGroupCode}-${shareName}"
    shareDisplayName="sh-$upperGroupCode-$shareName"

    mkdir -m 775 $sharePath
    chgrp "BIODESIGN$upperGroupCode\Domain Admins" $sharePath
    chgrp "BIODESIGN$upperGroupCode\Domain Admins" $sharePath

    net conf addshare $rootShareName $rootSharePath writeable=y guest_ok=n "$rootShareName"
    net conf setparm $rootShareName "browsable" "yes"    echo -e "    ${YELLOW}  - $shareDisplayName ($sharePath)${NC}"
done
