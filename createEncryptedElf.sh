#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\e[0;34m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
    echo -e "${BLUE}LP1 ($currentIP): ${RED}This Script must be run with sudo${NC}"
    exit
fi

githubPAT=''

cleanup()
{
    rm -rf /tmp/m159*
}

trap cleanup EXIT

Help()
{
   echo "This Script creates the whole Environment for the LB3 of Module M159"
   echo
   echo "Syntax: ./$(basename "$0") [-t|-h]"
   echo "options:"
   echo "    -t     Set the Personal Access Token for the Github Repositories. (required)"
   echo "    -h     Display this Help Message."
   echo
}

while getopts ":g:t:" option; do
    case $option in
        t)
            if [ $(curl -s -o /dev/null -I -w "%{http_code}" -u "lupree:$OPTARG" https://api.github.com/user) == "200" ]; then
                githubPAT=$OPTARG
            else
                echo -e "${BLUE}LP1 ($currentIP): ${RED}Invalid Github Personal Access Token.${NC}"
                echo
                Help
                exit
            fi;;
        h)
            Help
            exit;;
    esac
done

export DEBIAN_FRONTEND=noninteractive
apt update 2> /dev/null > /dev/null
apt upgrade -y 2> /dev/null > /dev/null
apt install -y shc build-essential git 2> /dev/null > /dev/null
export DEBIAN_FRONTEND=dialog

git clone https://lupree:$githubPAT@github.com/lupree/m159-lb3.git /tmp/m159-origin 2>/dev/null >/dev/null

git clone https://lupree:$githubPAT@github.com/lupree/m159.git /tmp/m159-target 2>/dev/null >/dev/null

cd /tmp/m159-origin
shc -f startScript.sh -o script 2>/dev/null >/dev/null
rm -f /tmp/m159-target/script 
mv /tmp/m159-origin/script /tmp/m159-target/script

cd /tmp/m159-target
git add script
git commit -m "Updated Executable"
git push

cleanup