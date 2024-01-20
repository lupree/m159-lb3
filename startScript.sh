#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e "LP1 | $currentIP: This Script must be run with sudo"
    exit
fi

currentIP=$(hostname -I)
kdcIP='192.168.110.61'
fileServerIP='192.168.110.62'
groupCode=''
githubPAT=''

cleanup()
{
    rm -rf /tmp/m159
}

trap cleanup EXIT

while getopts ":g:t:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "LP1 | $currentIP: Invalid groupCode. It must be 2 characters long and not empty"
                echo
                exit
            fi;;
        t)
            if [ $(curl -s -o /dev/null -I -w "%{http_code}" -u "Beutlus:$OPTARG" https://api.github.com/user) == "200" ]; then
                githubPAT=$OPTARG
            else
                echo -e "LP1 | $currentIP: Invalid Github Personal Access Token."
                echo
                exit
            fi;;
    esac
done

echo -e "LP1 | $currentIP: Updating Packages (This might take a few Minutes)"

export DEBIAN_FRONTEND=noninteractive
apt update 2> /dev/null > /dev/null
apt upgrade -y 2> /dev/null > /dev/null
export DEBIAN_FRONTEND=dialog

echo -e "LP1 | $currentIP: Installing Packages (This might take a few Minutes)"

export DEBIAN_FRONTEND=noninteractive
apt install -y git sshpass 2> /dev/null > /dev/null
export DEBIAN_FRONTEND=dialog

git clone https://Beutlus:$githubPAT@github.com/lupree/m159-lb3.git /tmp/m159 2>/dev/null >/dev/null

echo -e "LP1 | $currentIP: Running Main Script"

chmod +x /tmp/m159/mainScript.sh
/tmp/m159/mainScript.sh -g $groupCode

cleanup