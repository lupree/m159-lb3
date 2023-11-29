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
            fi;;
    esac
done

lowerGroupCode=$groupCode | tr '[:upper:]' '[:lower:]'
upperGroupCode=$groupCode | tr '[:lower:]' '[:upper:]'

echo -e "${YELLOW}Configuring Network File Server${NC}"

echo -e "${YELLOW}Configuring Network Settings${NC}"

echo -e "${YELLOW}Configuring Netplan${NC}"

netplanContent=$(cat << EOL
---
network:
  ethernets:
    eth0:
      addresses:
        - 192.168.110.62/24
      nameservers:
        addresses:
          - 192.168.110.61
        search:
          - biodesign$lowerGroupCode.lan
      routes:
        - to: default
          via: 192.168.110.2
  version: 2
EOL
)

netplanPath="/etc/netplan/00-eth0.yaml"
mv $netplanPath $netplanPath".old"
touch $netplanPath
chmod 600 $netplanPath
echo "$netplanContent" > $netplanPath
netplan apply 2> /dev/null > /dev/null

echo -e "${YELLOW}Configuring Search Domain in Resolved${NC}"

resolvedContent=$(cat << EOL
[Resolve]
Domains=biodesign$lowerGroupCode.lan
EOL
)

resolvedPath="/etc/systemd/resolved.conf"
mv $resolvedPath $resolvedPath".old"
touch $resolvedPath
chmod 644 $resolvedPath
echo "$resolvedContent" > $resolvedPath

systemctl restart systemd-resolved



echo -e "${YELLOW}Configuring Hosts File${NC}"

hostsContent=$(cat << EOL
127.0.0.1       localhost.localdomain                 localhost
127.0.0.1       vmLS2.biodesign$lowerGroupCode.lan    vmLS2
192.168.110.61  vmLS2.biodesign$lowerGroupCode.lan    vmLS2

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOL
)

hostsPath="/etc/hosts"
cat /dev/null > $hostsPath
echo $hostsContent > $hostsPath

echo -e "${YELLOW}Configuring Hostname${NC}"

hostnameContent=$(cat << EOL
vmLS2.biodesign$lowerGroupCode.lan
EOL
)

hostnamePath="/etc/hostname"
cat /dev/null > $hostnamePath
echo $hostnameContent > $hostnamePath

echo -e "${GREEN}Network Settings configured successfully${NC}"
echo -e "${YELLOW}Configuring Samba${NC}"

sambaContent=$(cat << EOL
[global]
	workgroup = BIODESIGN$upperGroupCode
	realm = BIODESIGN$upperGroupCode.LAN
	security = ADS
	winbind enum users = yes
	winbind enum groups = yes
	winbind use default domain = yes
	winbind refresh tickets = yes
	template shell = /bin/bash
	idmap config * : range = 10000 - 19999
	idmap config SAM159 : backend = rid
	idmap config SAM159 : range = 1000000 - 1999999
	inherit acls = yes
	store dos attributes = yes
	client ipc signing = auto
	vfs objects = acl_xattr
EOL
)

sambaPath="/etc/samba/smb.conf"
mv $sambaPath $sambaPath".old"
touch $sambaPath
chmod 644 $sambaPath
echo "$sambaContent" > $sambaPath
smbcontrol all reload-config

echo -e "${GREEN}Samba configured successfully${NC}"