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

echo -e "${BLUE}    KDC: ${YELLOW}Configuring Hosts File${NC}"

hostsPath="/etc/hosts"
cat /dev/null > $hostsPath
cat > $hostsPath << EOF
127.0.0.1       localhost.localdomain    localhost
127.0.0.1       vmLS1.biodesign$lowerGroupCode.lan    vmLS1
192.168.110.61  vmLS1.biodesign$lowerGroupCode.lan    vmLS1
192.168.110.61  vmLS1.biodesignXY.lan    vmLS1

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

echo -e "${BLUE}    KDC: ${YELLOW}Adding DNS Records${NC}"

samba-tool dns zonecreate vmls1 110.168.192.in-addr.arpa -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add 192.168.110.61 110.168.192.in-addr.arpa 61 PTR vmls1.biodesign$lowerGroupCode.lan -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmLP1 A 192.168.110.30 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmLS2 A 192.168.110.62 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmWP1 A 192.168.110.10 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan 110.168.192.in-addr.arpa 30 PTR vmLP1.biodesign$lowerGroupCode.lan -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan 110.168.192.in-addr.arpa 62 PTR vmLS2.biodesign$lowerGroupCode.lan -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan 110.168.192.in-addr.arpa 10 PTR vmWP1.biodesign$lowerGroupCode.lan -U administrator --password="SmL12345**" 2> /dev/null > /dev/null

samba_dnsupdate

echo -e "${BLUE}    KDC: ${YELLOW}Configuring Password Policies"

samba-tool domain passwordsettings set --complexity=off -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool domain passwordsettings set --history-length=0 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool domain passwordsettings set --min-pwd-age=0 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool domain passwordsettings set --max-pwd-age=0 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool user setexpiry Administrator --noexpiry -U administrator --password="SmL12345**" 2> /dev/null > /dev/null