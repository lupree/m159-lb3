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


echo -e "${BLUE}    KDC: ${YELLOW}Updating Packages (This might take a few Minutes)${NC}"

export DEBIAN_FRONTEND=noninteractive
apt update 2> /dev/null > /dev/null
apt upgrade -y 2> /dev/null > /dev/null
export DEBIAN_FRONTEND=dialog

echo -e "${BLUE}    KDC: ${GREEN}Packages updated successfully${NC}"

echo -e "${BLUE}    KDC: ${YELLOW}Configuring Network File Server${NC}"

echo -e "${BLUE}    KDC: ${YELLOW}Configuring Network Settings${NC}"

echo -e "${BLUE}    KDC: ${YELLOW}Configuring Netplan${NC}"

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
        - 192.168.110.61/24
      nameservers:
        addresses:
          - 192.168.110.2
        search:
          - biodesign$lowerGroupCode.lan
      routes:
        - to: default
          via: 192.168.110.2
  version: 2
EOF
netplan apply 2> /dev/null > /dev/null

echo -e "${BLUE}    KDC: ${YELLOW}Configuring Hosts File${NC}"

hostsPath="/etc/hosts"
cat /dev/null > $hostsPath
cat > $hostsPath << EOF
127.0.0.1       localhost.localdomain    localhost
127.0.0.1       vmLS1.biodesign$lowerGroupCode.lan    vmLS1
192.168.110.61  vmLS1.biodesign$lowerGroupCode.lan    vmLS1

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

echo -e "${BLUE}    KDC: ${YELLOW}Configuring Hostname${NC}"

hostnamePath="/etc/hostname"
cat /dev/null > $hostnamePath
cat > $hostnamePath << EOF
vmLS1.biodesign$lowerGroupCode.lan
EOF

unlink /etc/resolv.conf

resolvPath="/etc/resolv.conf"
sudo rm -f $resolvPath
sudo cat > $resolvPath << EOF
nameserver 8.8.8.8
search biodesign$lowerGroupCode.lan
EOF

echo -e "${BLUE}    KDC: ${GREEN}Network Settings configured successfully${NC}"
echo -e "${BLUE}    KDC: ${YELLOW}Configuring KDC Role${NC}"

rm -f /etc/samba/smb.conf /etc/samba/smb.conf.old
rm -f /etc/krb5.conf /etc/krb5.conf.old
samba-tool domain provision --realm "BIODESIGN$upperGroupCode.LAN" --domain "BIODESIGN$upperGroupCode" --adminpass "SmL12345**" --server-role "dc" --dns-backend "SAMBA_INTERNAL" --quiet 2> /dev/null > /dev/null

echo -e "${BLUE}    KDC: ${GREEN}KDC Role configured successfully${NC}"
echo -e "${BLUE}    KDC: ${YELLOW}Configuring Kerberos Authentication Settings${NC}"

kerberosPath="/etc/krb5.conf"
touch $kerberosPath
chmod 644 $kerberosPath
cat > $kerberosPath << EOF
[libdefaults]
	default_realm = BIODESIGN$upperGroupCode.LAN
	fcc-mit-ticketflags = true
    dns_lookup_realm = false
    dns_lookup_kdc = true
[realms]
	BIODESIGN$upperGroupCode.LAN = {
		kdc = vmLS1.biodesign$lowerGroupCode.lan
		admin_server = vmLS1.biodesign$lowerGroupCode.lan
        default_domain = biodesign$lowerGroupCode.lan
	}
[domain_realm]
	.biodesign$lowerGroupCode.lan = BIODESIGN$upperGroupCode.LAN
	biodesign$lowerGroupCode.lan = BIODESIGN$upperGroupCode.LAN
    vmLS1 =  BIODESIGN$upperGroupCode.LAN
EOF

echo -e "${BLUE}    KDC: ${GREEN}Kerberos Authentication Settings configured successfully${NC}"
echo -e "${BLUE}    KDC: ${YELLOW}Configuring DNS Settings${NC}"

systemctl mask smbd nmbd winbind 2> /dev/null > /dev/null
systemctl disable smbd nmbd winbind 2> /dev/null > /dev/null
systemctl stop smbd nmbd winbind 2> /dev/null > /dev/null
systemctl unmask samba-ad-dc 2> /dev/null > /dev/null
systemctl enable samba-ad-dc 2> /dev/null > /dev/null
systemctl start samba-ad-dc 2> /dev/null > /dev/null

systemctl stop systemd-resolved
systemctl disable systemd-resolved

resolvPath="/etc/resolv.conf"
sudo rm -f $resolvPath
sudo cat > $resolvPath << EOF
nameserver 192.168.110.61
search biodesign$lowerGroupCode.lan
EOF

echo -e "${BLUE}    KDC: ${GREEN}DNS Settings configured successfully${NC}"