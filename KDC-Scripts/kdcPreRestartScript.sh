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
EOL
)

netplanPath="/etc/netplan/00-eth0.yaml"
mv $netplanPath $netplanPath".old"
touch $netplanPath
chmod 600 $netplanPath
echo "$netplanContent" > $netplanPath
netplan apply

echo -e "${YELLOW}Configuring Hosts File${NC}"

hostsContent=$(cat << EOL
127.0.0.1       localhost.localdomain                 localhost
127.0.0.1       vmLS1.biodesign$lowerGroupCode.lan    vmLS1
192.168.110.61  vmLS1.biodesign$lowerGroupCode.lan    vmLS1

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
vmLS1.biodesign$lowerGroupCode.lan
EOL
)

hostnamePath="/etc/hostname"
cat /dev/null > $hostnamePath
echo $hostnameContent > $hostnamePath

echo -e "${GREEN}Network Settings configured successfully${NC}"
echo -e "${YELLOW}Configuring KDC Role${NC}"

samba-tool domain provision << EOF
BIODESIGN$upperGroupCode.LAN
BIODESIGN$upperGroupCode
dc
SAMBA_INTERNAL
8.8.8.8
SmL12345**

systemctl disable systemd-resolved
systemctl stop systemd-resolved
mv /etc/resolv.conf /etc/resolv.conf.old

resolvContent =$(cat << EOL
nameserver 192.168.110.61
search biodesign$lowerGroupCode.lan
EOL
)

echo -e "${GREEN}KDC Role configured successfully${NC}"
echo -e "${YELLOW}Configuring DNS Settings${NC}"

resolvPath="/etc/resolv.conf"
mv $resolvPath $resolvPath".old"
touch $resolvPath
chmod 644 $resolvPath
echo "$resolvContent" > $resolvPath


systemctl unmask samba-ad-dc 
systemctl enable samba-ad-dc
systemctl start samba-ad-dc

echo -e "${GREEN}DNS Settings configured successfully${NC}"
echo -e "${YELLOW}Configuring Kerberos Authentication Settings${NC}"

kerberosContent =$(cat << EOL
nameserver 192.168.110.61
search biodesign$lowerGroupCode.lan
EOL
)

kerberosPath="/etc/krb5.conf"
mv $kerberosPath $kerberosPath".old"
touch $kerberosPath
chmod 644 $kerberosPath
echo "$kerberosContent" > $kerberosPath

echo -e "${GREEN}Kerberos Authentication Settings configured successfully${NC}"
echo -e "${YELLOW}Adding DNS Records${NC}"

samba-tool dns zonecreate vmls1 110.168.192.in-addr.arpa -U administrator << EOF
SmL12345**
samba-tool dns add 192.168.110.61 110.168.192.in-addr.arpa 61 PTR vmls1.biodesign$lowerGroupCode.lan -U administrator << EOF
SmL12345**
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmLP1 A 192.168.110.30 -U administrator << EOF
SmL12345**
samba-tool dns add vmLS1.biodesignC4.lan biodesignC4.lan vmLS2 A 192.168.110.62 -U administrator << EOF
SmL12345**
samba-tool dns add vmLS1.biodesignC4.lan 110.168.192.in-addr.arpa 30 PTR vmLP1.biodesignC4 -U administrator << EOF
SmL12345**
samba-tool dns add vmLS1.biodesignC4.lan 110.168.192.in-addr.arpa 62 PTR vmLS2.biodesignC4 -U administrator << EOF
SmL12345**

echo -e "${GREEN}DNS Records added successfully${NC}"