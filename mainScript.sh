#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\e[0;34m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
    echo -e "${BLUE}KDC: ${RED}This Script must be run with sudo${NC}"
    exit
fi

kdcIP='192.168.110.61'
fileServerIP='192.168.110.62'
groupCode=''

while getopts ":g:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "${BLUE}KDC: ${RED}Invalid groupCode. It must be 2 characters long and not empty${NC}"
                exit
            fi;;
    esac
done

rm -f /home/vmadmin/.ssh/known_hosts

echo -e "${GREEN}Test Script works"

# echo -e "${BLUE}KDC: ${YELLOW}Generating new SSH Keypair${NC}"
# 
# ssh-keygen -t rsa -b 2048 -f "$HOME/.ssh/id_rsa" -N ""
# 
# echo -e "${BLUE}KDC: ${YELLOW}Copying new SSH Keypair to KDC${NC}"
# ssh-copy-id -o StrictHostKeyChecking=no vmadmin@$kdcIP << EOF
# sml12345
# EOF
# 
# echo -e "${BLUE}KDC: ${YELLOW}Copying new SSH Keypair to File Server${NC}"
# ssh-copy-id -o StrictHostKeyChecking=no vmadmin@$fileServerIP << EOF
# sml12345
# EOF
# 
# if ping -c 1 $kdcIP &> /dev/null; then
#     scp -o StrictHostKeyChecking=no ./KDC-Scripts/kdcPreRestartScript.sh vmadmin@$kdcIP:~/kdcPreRestartScript.sh
#     echo -e "${BLUE}KDC: ${GREEN}KDC-Script has been copied to the KDC${NC}"
#     echo -e "${BLUE}KDC: ${BLUE}Running KDC-Script${NC}"
#     ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo chmod +x ./kdcPreRestartScript.sh; sudo ./kdcPreRestartScript.sh -g $groupCode; sudo rm ./kdcPreRestartScript.sh; sudo reboot"
#     echo -e "${BLUE}KDC: ${GREEN}Restarting KDC${NC}"
#     until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
#         sleep 5
#     done
#     scp -o StrictHostKeyChecking=no ./KDC-Scripts/kdcPostRestartScript.sh vmadmin@$kdcIP:~/kdcPostRestartScript.sh
#     ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo chmod +x ./kdcPostRestartScript.sh; sudo ./kdcPostRestartScript.sh -g $groupCode; sudo rm ./kdcPostRestartScript.sh"
#     until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
#         sleep 5
#     done
#     if nslookup "google.com" &> /dev/null; then
#         echo -e "${BLUE}KDC: ${GREEN}KDC-Script has run successfully${NC}"
#     else
#         echo -e "${BLUE}KDC: ${RED}Name resolution on KDC does not work. Please check DNS Settings${NC}"
#     fi
# else
#     echo -e "${BLUE}KDC: ${RED}KDC is unreachable${NC}"
#     exit
# fi
# 
# if ping -c 1 $fileServerIP &> /dev/null; then
#     scp ./FS-Scripts/fileServerPreRestartScript.sh vmadmin@$fileServerIP:~/fileServerPreRestartScript.sh
#     echo -e "${BLUE}KDC: ${GREEN}Fileserver-Script has been copied to the Fileserver${NC}"
#     echo -e "${BLUE}KDC: ${BLUE}Running Fileserver-Script${NC}"
#     ssh vmadmin@$fileServerIP "sudo chmod +x ./fileServerPreRestartScript.sh; sudo ./fileServerPreRestartScript.sh -g $groupCode; sudo rm ./fileServerPreRestartScript.sh; reboot"
#     echo -e "${BLUE}KDC: ${GREEN}Restarting Fileserver${NC}"
#     until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
#         sleep 5
#     done
#     scp ./FS-Scripts/fileServerPostRestartScript.sh vmadmin@$kdcIP:~/fileServerPostRestartScript.sh
#     ssh vmadmin@$kdcIP "sudo chmod +x ./fileServerPostRestartScript.sh; sudo ./fileServerPostRestartScript.sh -g $groupCode; sudo rm ./kdcPostRestartScript.sh ; sudo reboot"
#     echo -e "${BLUE}KDC: ${GREEN}Restarting Fileserver${NC}"
#     until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
#         sleep 5
#     done
#     if nslookup "google.com" &> /dev/null; then
#         echo -e "${BLUE}KDC: ${GREEN}Fileserver-Script has run successfully${NC}"
#     else
#         echo -e "${BLUE}KDC: ${RED}Name resolution on Fileserver does not work. Please check DNS Settings${NC}"
#     fi
# else
#     echo -e "${BLUE}KDC: ${RED}Fileserver is unreachable${NC}"
#     exit
# fi
