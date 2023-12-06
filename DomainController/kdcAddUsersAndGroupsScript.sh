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

departmentData="Finanzen,Verwaltung
Einkauf,Verwaltung
Verkauf,Verwaltung
HR,Verwaltung
Werkstatt,
GL,
Kundendienst,
Verwaltung,"

$groupData="gl,GL
grp-$upperGroupCode-hr,HR
grp-$upperGroupCode-verkauf,Verkauf
grp-$upperGroupCode-einkauf,Einkauf
grp-$upperGroupCode-finanzen,Finanzen
grp-$upperGroupCode-kundendienst,Kundendienst
grp-$upperGroupCode-werkstatt,Werkstatt
"

$accessGroupData="acl-$upperGroupCode-gl-m,,GL
acl-$upperGroupCode-gl-r,GL
acl-$upperGroupCode-hr-m,HR
acl-$upperGroupCode-hr-r,HR
acl-$upperGroupCode-verkauf-m,Verkauf
acl-$upperGroupCode-verkauf-r,Verkauf
acl-$upperGroupCode-einkauf-m,Einkauf
acl-$upperGroupCode-einkauf-r,Einkauf
acl-$upperGroupCode-finanzen-m,Finanzen
acl-$upperGroupCode-finanzen-r,Finanzen
acl-$upperGroupCode-kundendienst-m,Kundendienst
acl-$upperGroupCode-kundendienst-r,Kundendienst
acl-$upperGroupCode-werkstatt-m,Werkstatt
acl-$upperGroupCode-werkstatt-r,Werkstatt
acl-$upperGroupCode-public-m,Public
acl-$upperGroupCode-public-r,Public
"

userData="grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-werkstatt,Werkstatt,acl-$upperGroupCode-public-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-werkstatt-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-kundendienst,Kundendienst,acl-$upperGroupCode-public-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-kundendienst-m
grp-$upperGroupCode-finanzen,Finanzen,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-finanzen-m; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-finanzen,Finanzen,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-finanzen-m; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-finanzen,Finanzen,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-finanzen-m; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-einkauf,Einkauf,acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r; acl-$upperGroupCode-einkauf-m
grp-$upperGroupCode-einkauf,Einkauf,acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r; acl-$upperGroupCode-einkauf-m
grp-$upperGroupCode-einkauf,Einkauf,acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r; acl-$upperGroupCode-einkauf-m
grp-$upperGroupCode-verkauf,Verkauf,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-verkauf,Verkauf,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-verkauf,Verkauf,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-verkauf,Verkauf,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-verkauf,Verkauf,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-verkauf,Verkauf,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-verkauf,Verkauf,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-verkauf,Verkauf,acl-$upperGroupCode-verkauf-m; acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r
grp-$upperGroupCode-hr,HR,acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r; acl-$upperGroupCode-hr-m
grp-$upperGroupCode-gl,GL,acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-gl-m; acl-$upperGroupCode-gl-r
grp-$upperGroupCode-gl,GL,acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-gl-m; acl-$upperGroupCode-gl-r
"

echo -e "${BLUE}    KDC | $currentIP: ${YELLOW}Creating OUs${NC}"

echo "$userData" | while IFS=',' read -r displayName department
do
    DN=""
    if [ $department ]; then
        $DN="OU=$upperGroupCode$displayName,OU=$upperGroupCode$department,DC=BIODESIGN$upperGroupCode,DC=LAN"
        samba-tool ou create $DN -Uadministrator
    else
        $DN="OU=$upperGroupCode$displayName,DC=BIODESIGN$upperGroupCode,DC=LAN"
        samba-tool ou create $DN -Uadministrator
    fi
    echo -e "                      ${YELLOW}  - $department${NC}"
done

echo -e "${BLUE}    KDC | $currentIP: ${YELLOW}Creating Groups${NC}"

echo "$groupData" | while IFS=',' read -r groupName department
do
    departmentDN=""
    if [ $department ]; then
        $departmentDN="OU=$upperGroupCode$displayName,OU=$upperGroupCode$department,DC=BIODESIGN$upperGroupCode,DC=LAN"
    else
        $departmentDN="OU=$upperGroupCode$displayName,DC=BIODESIGN$upperGroupCode,DC=LAN"
    fi
    samba-tool group add "grp-$lowerGroupCode-$groupName" -U "administrator%SmL12345**"
    samba-tool group move "$groupName" "$departmentDN" -U "administrator%SmL12345**"
    echo -e "                      ${YELLOW}  - $groupName${NC}"

done

echo -e "${BLUE}    KDC | $currentIP: ${YELLOW}Creating Access Control Groups${NC}"

echo "$accessGroupData" | while IFS=',' read -r groupName department
do
    departmentDN=""
    if [ $department ]; then
        $departmentDN="OU=$upperGroupCode$displayName,OU=$upperGroupCode$department,DC=BIODESIGN$upperGroupCode,DC=LAN"
    elif [ $department == "Public"]; then
        $departmentDN="DC=BIODESIGN$upperGroupCode,DC=LAN"
    else
        $departmentDN="OU=$upperGroupCode$displayName,DC=BIODESIGN$upperGroupCode,DC=LAN"
    fi
    samba-tool group add "$groupName" -U "administrator%SmL12345**"
    samba-tool group move "$groupName" "$departmentDN" -U "administrator%SmL12345**"
    echo -e "                      ${YELLOW}  - $groupName${NC}"
done

echo -e "${BLUE}    KDC | $currentIP: ${YELLOW}Creating Users${NC}"

echo "$userData" | while IFS=',' read -r groupMemberships department accessControllGroupMemberships
do
    departmentDN=""
    if [ $department ]; then
        $departmentDN="OU=$upperGroupCode$displayName,OU=$upperGroupCode$department,DC=BIODESIGN$upperGroupCode,DC=LAN"
    else
        $departmentDN="OU=$upperGroupCode$displayName,DC=BIODESIGN$upperGroupCode,DC=LAN"
    fi
    nameAPIResponse=$(curl srv1.lupree.com:3000)
    firstName=$(echo $nameAPIResponse | jq -r '.firstName')
    lastName=$(echo $nameAPIResponse | jq -r '.lastName')
    userName=$(echo "$firstName.$lastName-$upperGroupCode" | tr '[:upper:]' '[:lower:]')
    userEmail="$userName@biodesign$lowerGroupCode.lan"

    samba-tool user create "$userName" "SmL12345**" --given-name="$firstName" --surname="$lastName" --mail-address="$userEmail" -U "administrator%SmL12345**"
    samba-tool user move "$userName" "$departmentDN" -U "administrator%SmL12345**"
    echo -e "                      ${YELLOW}  - $userEmail${NC}"
done