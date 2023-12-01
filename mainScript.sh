#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\e[0;34m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This Script must be run with sudo${NC}"
    exit
fi

kdcIP='192.168.110.61'
fileServerIP='192.168.110.62'
groupCode=''

Help()
{
   echo "This Script creates the whole Environment for the LB3 of Module M159"
   echo
   echo "Syntax: ./$(basename "$0") [-g|-h]"
   echo "options:"
   echo "    -g     Set the Group Code. (required)"
   echo "    -h     Display this Help Message."
   echo
}

while getopts ":g:k:f:h:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "${RED}Invalid groupCode. It must be 2 characters long and not empty${NC}"
                echo
                Help
                exit
            fi;;
    esac
done

echo -e "${YELLOW}Verifying Input Variables${NC}"

if [ -z "$groupCode" ] || [ -z "$kdcIP" ] || [ -z "$fileServerIP" ]; then
    echo -e "${RED}One or more required parameters are missing${NC}"
    echo
    Help
    exit
fi

echo -e "${YELLOW}Input Variables successfully verified${NC}"

if ping -c 1 $kdcIP &> /dev/null; then
    scp ./KDC-Scripts/kdcPreRestartScript.sh vmadmin@$kdcIP:~/kdcPreRestartScript.sh
    echo -e "${GREEN}KDC-Script has been copied to the KDC${NC}"
    echo -e "${BLUE}Running KDC-Script${NC}"
    ssh vmadmin@$kdcIP "sudo chmod +x ./kdcPreRestartScript.sh; sudo ./kdcPreRestartScript.sh -g $groupCode; sudo rm ./kdcPreRestartScript.sh; sudo reboot"
    echo -e "${GREEN}Restarting KDC${NC}"
    until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
        sleep 5
    done
    scp ./KDC-Scripts/kdcPostRestartScript.sh vmadmin@$kdcIP:~/kdcPostRestartScript.sh
    ssh vmadmin@$kdcIP "sudo chmod +x ./kdcPostRestartScript.sh; sudo ./kdcPostRestartScript.sh -g $groupCode; sudo rm ./kdcPostRestartScript.sh"
    echo -e "${GREEN}KDC-Script has run successfully${NC}"
else
    echo -e "${RED}KDC is unreachable${NC}"
    exit
fi

if ping -c 1 $fileServerIP &> /dev/null; then
    scp ./FS-Scripts/fileServerPreRestartScript.sh vmadmin@$fileServerIP:~/fileServerPreRestartScript.sh
    echo -e "${GREEN}Fileserver-Script has been copied to the Fileserver${NC}"
    echo -e "${BLUE}Running Fileserver-Script${NC}"
    ssh vmadmin@$fileServerIP "sudo chmod +x ./fileServerPreRestartScript.sh; sudo ./fileServerPreRestartScript.sh -g $groupCode; sudo rm ./fileServerPreRestartScript.sh; reboot"
    echo -e "${GREEN}Restarting Fileserver${NC}"
    until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
        sleep 5
    done
    scp ./KDC-Scripts/fileServerPostRestartScript.sh vmadmin@$kdcIP:~/fileServerPostRestartScript.sh
    ssh vmadmin@$kdcIP "sudo chmod +x ./fileServerPostRestartScript.sh; sudo ./fileServerPostRestartScript.sh -g $groupCode; sudo rm ./kdcPostRestartScript.sh ; sudo reboot"
    echo -e "${GREEN}Restarting Fileserver${NC}"
    until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
        sleep 5
    done
    echo -e "${GREEN}Fileserver-Script has run successfully${NC}"
else
    echo -e "${RED}Fileserver is unreachable${NC}"
    exit
fi