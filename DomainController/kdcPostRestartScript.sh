#!/bin/bash

groupCode=''
currentIP=$(hostname -I)

while getopts ":g:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "    KDC | $currentIP: Invalid groupCode. It must be 2 characters long and not empty"
                exit
            fi;;
    esac
done

lowerGroupCode=$(echo $groupCode | tr '[:upper:]' '[:lower:]')
upperGroupCode=$(echo $groupCode | tr '[:lower:]' '[:upper:]')

echo -e "    KDC | $currentIP: Configuring Hosts File"

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

echo -e "    KDC | $currentIP: Adding DNS Records"

samba-tool dns zonecreate vmls1 110.168.192.in-addr.arpa -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add 192.168.110.61 110.168.192.in-addr.arpa 61 PTR vmls1.biodesign$lowerGroupCode.lan -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmLP1 A 192.168.110.30 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmLS2 A 192.168.110.62 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan biodesign$lowerGroupCode.lan vmWP1 A 192.168.110.10 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan 110.168.192.in-addr.arpa 30 PTR vmLP1.biodesign$lowerGroupCode.lan -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan 110.168.192.in-addr.arpa 62 PTR vmLS2.biodesign$lowerGroupCode.lan -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool dns add vmLS1.biodesign$lowerGroupCode.lan 110.168.192.in-addr.arpa 10 PTR vmWP1.biodesign$lowerGroupCode.lan -U administrator --password="SmL12345**" 2> /dev/null > /dev/null

samba_dnsupdate

echo -e "    KDC | $currentIP: Configuring Password Policies"

samba-tool domain passwordsettings set --complexity=off -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool domain passwordsettings set --history-length=0 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool domain passwordsettings set --min-pwd-age=0 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool domain passwordsettings set --max-pwd-age=0 -U administrator --password="SmL12345**" 2> /dev/null > /dev/null
samba-tool user setexpiry Administrator --noexpiry -U administrator --password="SmL12345**" 2> /dev/null > /dev/null