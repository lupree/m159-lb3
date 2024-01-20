#!/bin/bash

groupCode=''
currentIP=$(hostname -I)

while getopts ":g:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "    FS  | $currentIP: Invalid groupCode. It must be 2 characters long and not empty"
                exit
            fi;;
    esac
done

lowerGroupCode=$(echo $groupCode | tr '[:upper:]' '[:lower:]')
upperGroupCode=$(echo $groupCode | tr '[:lower:]' '[:upper:]')

echo -e "    FS  | $currentIP: Joining Realm"

net ads join -U "Administrator%SmL12345**" 2> /dev/null > /dev/null

echo -e "    FS  | $currentIP: Configuring Winbind"

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

echo -e "    FS  | $currentIP: Configuring Samba Registry Management"

sambaPath="/etc/samba/smb.conf"

net conf import $sambaPath
rm -f $sambaPath".old"
mv $sambaPath $sambaPath".old"
touch $sambaPath
chmod 644 $sambaPath
cat > $sambaPath << EOF
[global]
	config backend = registry
EOF