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
                echo -e "${BLUE}    KDC: ${RED}Invalid groupCode. It must be 2 characters long and not empty${NC}"
                exit
            fi;;
    esac
done

lowerGroupCode=$(echo $groupCode | tr '[:upper:]' '[:lower:]')
upperGroupCode=$(echo $groupCode | tr '[:lower:]' '[:upper:]')

echo -e "${BLUE}    KDC: ${YELLOW}Adding DNS Records${NC}"

samba-tool dns zonecreate vmls1 110.168.192.in-addr.arpa -U administrator << EOF
SmL12345**
EOF
samba-tool dns add 192.168.110.61 110.168.192.in-addr.arpa 61 PTR vmls1.biodesign$lowerGroupCode.lan -U administrator  << EOF
SmL12345**
EOF
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmLP1 A 192.168.110.30 -U administrator << EOF
SmL12345**
EOF
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmLS2 A 192.168.110.62 -U administrator << EOF
SmL12345**
EOF
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan 110.168.192.in-addr.arpa 30 PTR vmLP1.biodesign$lowerGroupCode -U administrator << EOF
SmL12345**
EOF
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan 110.168.192.in-addr.arpa 62 PTR vmLS2.biodesign$lowerGroupCode -U administrator << EOF
SmL12345**
EOF

echo -e "${BLUE}    KDC: ${GREEN}DNS Records added successfully${NC}"