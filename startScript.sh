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

Help()
{
   echo "This Script creates the whole Environment for the LB3 of Module M159"
   echo
   echo "Syntax: ./$(basename "$0") [-g|-t|-h]"
   echo "options:"
   echo "    -g     Set the Group Code. (required)"
   echo "    -t     Set the Personal Access Token for the Github Repository. (required)"
   echo "    -h     Display this Help Message."
   echo
}

while getopts ":g:t:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "${BLUE}LP1 ($currentIP): ${RED}Invalid groupCode. It must be 2 characters long and not empty${NC}"
                echo
                Help
                exit
            fi;;
        t)
            if [ $(curl -s -o /dev/null -I -w "%{http_code}" -u "Beutlus:$OPTARG" https://api.github.com/user) == "200" ]; then
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

echo -e "${BLUE}LP1 ($currentIP): ${YELLOW}Verifying Input Variables${NC}"

if [ -z "$groupCode" ] || [ -z "$githubPAT" ]; then
    echo -e "${BLUE}LP1 ($currentIP): ${RED}One or more required parameters are missing${NC}"
    Help
    exit
fi

echo -e "${BLUE}LP1 ($currentIP): ${YELLOW}Updating Packages (This might take a few Minutes)${NC}"

export DEBIAN_FRONTEND=noninteractive
apt update 2> /dev/null > /dev/null
apt upgrade -y 2> /dev/null > /dev/null
export DEBIAN_FRONTEND=dialog

echo -e "${BLUE}LP1 ($currentIP): ${YELLOW}Installing Packages (This might take a few Minutes)${NC}"

export DEBIAN_FRONTEND=noninteractive
apt install -y git sshpass 2> /dev/null > /dev/null
export DEBIAN_FRONTEND=dialog

git clone https://Beutlus:$githubPAT@github.com/lupree/m159-lb3.git /tmp/m159 2>/dev/null >/dev/null

echo -e "${BLUE}LP1 ($currentIP): ${YELLOW}Running Main Script${NC}"

chmod +x /tmp/m159/mainScript.sh
/tmp/m159/mainScript.sh -g $groupCode

cleanup