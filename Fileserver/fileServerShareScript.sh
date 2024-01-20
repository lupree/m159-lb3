#!/bin/bash

groupCode=''

while getopts ":g:" option; do
    case $option in
    g)
        if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
        groupCode=$OPTARG
        else
        echo -e "Invalid groupCode. It must be 2 characters long and not empty"
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

echo -e "    FS  | $currentIP: Creating Shares"

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
    net conf setparm $rootShareName "browsable" "yes"    echo -e "      - $shareDisplayName ($sharePath)"
done
