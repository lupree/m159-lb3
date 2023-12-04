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

lowerGroupCode=$(echo $groupCode | tr '[:upper:]' '[:lower:]')
upperGroupCode=$(echo $groupCode | tr '[:lower:]' '[:upper:]')

echo -e "${YELLOW}Configuring Network File Server${NC}"

echo -e "${YELLOW}Configuring Network Settings${NC}"

echo -e "${YELLOW}Configuring Netplan${NC}"

netplanPath="/etc/netplan/00-eth0.yaml"
mv $netplanPath $netplanPath".old"
touch $netplanPath
chmod 600 $netplanPath
cat > $netplanPath << EOF
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
EOF
netplan apply 2> /dev/null > /dev/null




echo -e "${YELLOW}Configuring Hosts File${NC}"

hostsPath="/etc/hosts"
cat /dev/null > $hostsPath
cat > $hostsPath << EOF
127.0.0.1       localhost.localdomain                 localhost
127.0.0.1       vmLS2.biodesign$lowerGroupCode.lan    vmLS2
192.168.110.61  vmLS2.biodesign$lowerGroupCode.lan    vmLS2

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

echo -e "${YELLOW}Configuring Hostname${NC}"

hostnamePath="/etc/hostname"
cat /dev/null > $hostnamePath
cat > $hostnamePath << EOF
vmLS2.biodesign$lowerGroupCode.lan
EOF

echo -e "${YELLOW}Configuring Search Domain in Resolved${NC}"

resolvedPath="/etc/systemd/resolved.conf"
mv $resolvedPath $resolvedPath".old"
touch $resolvedPath
chmod 644 $resolvedPath
cat > $resolvedPath << EOF
[Resolve]
Domains=biodesign$lowerGroupCode.lan
EOF

systemctl restart systemd-resolved

echo -e "${GREEN}Network Settings configured successfully${NC}"
echo -e "${YELLOW}Installing Packages${NC}"

export DEBIAN_FRONTEND=noninteractive
apt update 2> /dev/null > /dev/null
apt upgrade -y 2> /dev/null > /dev/null
apt install -y samba samba-common-bin smbclient heimdal-clients libpam-heimdal 2> /dev/null > /dev/null
apt install -y libnss-winbind libpam-winbind 2> /dev/null > /dev/null
export DEBIAN_FRONTEND=dialog

echo -e "${GREEN}Packages installed successfully${NC}"
echo -e "${YELLOW}Configuring Samba${NC}"

sambaPath="/etc/samba/smb.conf"
mv $sambaPath $sambaPath".old"
touch $sambaPath
chmod 644 $sambaPath
cat > $sambaPath << EOF
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
	idmap config BIODESIGN$upperGroupCode : backend = rid
	idmap config BIODESIGN$upperGroupCode : range = 1000000 - 1999999
	inherit acls = yes
	store dos attributes = yes
	client ipc signing = auto
	vfs objects = acl_xattr
EOF
smbcontrol all reload-config

echo -e "${GREEN}Samba configured successfully${NC}"