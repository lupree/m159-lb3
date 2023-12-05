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
                echo -e "${BLUE}    FS: ${RED}Invalid groupCode. It must be 2 characters long and not empty${NC}"
                exit
            fi;;
    esac
done

lowerGroupCode=$(echo $groupCode | tr '[:upper:]' '[:lower:]')
upperGroupCode=$(echo $groupCode | tr '[:lower:]' '[:upper:]')

echo -e "${BLUE}    FS: ${YELLOW}Joining Realm${NC}"

net ads join -U Administrator << EOF
SmL12345**
EOF

echo -e "${BLUE}    FS: ${GREEN}Real joined successfully${NC}"
echo -e "${BLUE}    FS: ${YELLOW}Configuring Winbind${NC}"


winbindPath="/etc/nsswitch.conf"
mv $winbindPath $winbindPath".old"
touch $winbindPath
chmod 644 $winbindPath
cat > $winbindPath << EOF
passwd:         files systemd winbind
group:          files systemd winbind
shadow:         files
gshadow:        files

hosts:          files dns
networks:       files

protocols:      db files
services:       db files
ethers:         db files
rpc:            db files

netgroup:       nis
EOF

echo -e "${BLUE}    FS: ${GREEN}Winbind configured successfully${NC}"
echo -e "${BLUE}    FS: ${YELLOW}Configuring Samba Registry Management${NC}"

sambapath="/etc/samba/smb.conf"

net conf import $sambaPath
rm $sambaPath".old"
mv $sambaPath $sambaPath".old"
touch $sambaPath
chmod 644 $sambapath
cat > $sambaPath << EOF
[global]
	config backend = registry
EOF

echo -e "${BLUE}    FS: ${GREEN}Samba Registry Management configured successfully${NC}"
echo -e "${BLUE}    FS: ${YELLOW}${NC}"