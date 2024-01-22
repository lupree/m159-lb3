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

departmentData="Verwaltung,
Finanzen,Verwaltung
Einkauf,Verwaltung
Verkauf,Verwaltung
HR,Verwaltung
Werkstatt,
GL,
Kundendienst,"

groupData="grp-$upperGroupCode-gl,GL
grp-$upperGroupCode-hr,HR
grp-$upperGroupCode-verkauf,Verkauf
grp-$upperGroupCode-einkauf,Einkauf
grp-$upperGroupCode-finanzen,Finanzen
grp-$upperGroupCode-kundendienst,Kundendienst
grp-$upperGroupCode-werkstatt,Werkstatt"

accessGroupData="acl-$upperGroupCode-gl-m,,GL
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
acl-$upperGroupCode-werkstatt-r,Werkstatt"

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
grp-$upperGroupCode-gl,GL,acl-$upperGroupCode-einkauf-r; acl-$upperGroupCode-public-r; acl-$upperGroupCode-verkauf-r; acl-$upperGroupCode-finanzen-r; acl-$upperGroupCode-kundendienst-r; acl-$upperGroupCode-public-m; acl-$upperGroupCode-hr-r; acl-$upperGroupCode-werkstatt-r; acl-$upperGroupCode-gl-m; acl-$upperGroupCode-gl-r"

echo -e "    KDC | $currentIP: Installing Packages (This might take a few Minutes)"

export DEBIAN_FRONTEND=noninteractive
apt install -y jq 2> /dev/null > /dev/null
export DEBIAN_FRONTEND=dialog

echo -e "    KDC | $currentIP: Creating OUs"

rootOUDN="OU=Biodesign$upperGroupCode,DC=BIODESIGN$upperGroupCode,DC=LAN"
samba-tool ou create $rootOUDN  -U "administrator%SmL12345**" 2> /dev/null > /dev/null

echo "$departmentData" | while IFS=',' read -r displayName department
do
    if [ $department ]; then
    DN="OU=$upperGroupCode$displayName,OU=$upperGroupCode$department,OU=Biodesign$upperGroupCode,DC=BIODESIGN$upperGroupCode,DC=LAN"
    samba-tool ou create $DN  -U "administrator%SmL12345**" # 2> /dev/null > /dev/null
    else
    DN="OU=$upperGroupCode$displayName,OU=Biodesign$upperGroupCode,DC=BIODESIGN$upperGroupCode,DC=LAN"
    samba-tool ou create $DN  -U "administrator%SmL12345**" # 2> /dev/null > /dev/null
    fi
    echo -e "      - $displayName"
done

echo -e "    KDC | $currentIP: Creating Groups"

echo "$groupData" | while IFS=',' read -r groupName department
do
    departmentDN=$(samba-tool ou list | grep $department | cut -d "=" -f 2)
    samba-tool group add "$groupName" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
    samba-tool group move "$groupName" "$departmentDN" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
    echo -e "      - $groupName"
done

echo -e "    KDC | $currentIP: Creating Access Control Groups"

samba-tool group add "acl-$upperGroupCode-public-m" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
samba-tool group move "acl-$upperGroupCode-public-m" "OU=Biodesign$upperGroupCode,DC=BIODESIGN$upperGroupCode,DC=LAN" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
echo -e "      - acl-$upperGroupCode-public-m"

samba-tool group add "acl-$upperGroupCode-public-r" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
samba-tool group move "acl-$upperGroupCode-public-r" "OU=Biodesign$upperGroupCode,DC=BIODESIGN$upperGroupCode,DC=LAN" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
echo -e "      - acl-$upperGroupCode-public-r"

echo "$accessGroupData" | while IFS=',' read -r groupName department
do
    departmentDN=$(samba-tool ou list | grep $department | cut -d "=" -f 2)
    samba-tool group add "$groupName" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
    samba-tool group move "$groupName" "$departmentDN" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
    echo -e "      - $groupName"
done

echo -e "    KDC | $currentIP: Creating Users"

echo "$userData" | while IFS=',' read -r groupMemberships department accessControllGroupMemberships
do
    departmentDN=""
    if [ $department ]; then
    departmentDN="OU=$upperGroupCode$displayName,OU=$upperGroupCode$department,OU=Biodesign$upperGroupCode,DC=BIODESIGN$upperGroupCode,DC=LAN"
    else
    departmentDN="OU=$upperGroupCode$displayName,OU=Biodesign$upperGroupCode,DC=BIODESIGN$upperGroupCode,DC=LAN"
    fi
    nameAPIResponse=$(curl -s https://names.lupree.dev/api/trpc/names.getRandomNames)
    firstName=$(echo $nameAPIResponse | jq -r '.result.data.json.firstName')
    lastName=$(echo $nameAPIResponse | jq -r '.result.data.json.lastName')
    userName=$(echo "$firstName.$lastName-$upperGroupCode" | tr '[:upper:]' '[:lower:]')
    userEmail="$userName@biodesign$lowerGroupCode.lan"

    samba-tool user create "$userName" "SmL12345**" --given-name="$firstName" --surname="$lastName" --mail-address="$userEmail" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
    samba-tool user move "$userName" "$departmentDN" -U "administrator%SmL12345**" 2> /dev/null > /dev/null
    echo -e "    KDC | $currentIP: Creating OUs"
    echo -e "      - $userEmail:"

    echo -e "          Group Memberships:"
    IFS=';' read -ra groups <<< $groupMemberships
    for group in "${groups[@]}"; do
    samba-tool group addmembers $group $userName -U "administrator%SmL12345**" 2> /dev/null > /dev/null
    echo -e "            - $group:"
    done

    echo -e "          AccessControllGroup Memberships:"
    IFS=';' read -ra accessControllGroups <<< $accessControllGroupMemberships
    for accessControllGroup in "${accessControllGroups[@]}"; do
    samba-tool group addmembers $accessControllGroup $userName -U "administrator%SmL12345**" 2> /dev/null > /dev/null
    echo -e "            - $accessControllGroup:"
    done
done