#!/bin/bash

cd /tmp/m159
cd /tmp/m159

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\e[0;34m'
NC='\033[0m'

kdcIP='192.168.110.61'
fileServerIP='192.168.110.62'
groupCode=''

while getopts ":g:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "${BLUE}LP1: ${RED}Invalid groupCode. It must be 2 characters long and not empty${NC}"
                exit
            fi;;
    esac
done

rm -f /home/vmadmin/.ssh/known_hosts

echo -e "${BLUE}LP1: ${YELLOW}Generating new SSH Keypair${NC}"

rm -f "$HOME/.ssh/id_rsa"
rm -f "$HOME/.ssh/id_rsa.pub"

ssh-keygen -t rsa -b 2048 -f "$HOME/.ssh/id_rsa" -N "" 2> /dev/null >/dev/null

echo -e "${BLUE}LP1: ${YELLOW}Copying SSH Keypair to KDC${NC}"
sshpass -p "sml12345" ssh-copy-id -o StrictHostKeyChecking=no vmadmin@$kdcIP 2> /dev/null >/dev/null

echo -e "${BLUE}LP1: ${YELLOW}Copying SSH Keypair to File Server${NC}"
sshpass -p "sml12345" ssh-copy-id -o StrictHostKeyChecking=no vmadmin@$fileServerIP 2> /dev/null >/dev/null

if ping -c 1 $kdcIP &> /dev/null; then
    pwd
    scp -o StrictHostKeyChecking=no ./DomainController/kdcPreRestartScript.sh vmadmin@$kdcIP:/tmp/kdcPreRestartScript.sh 2> /dev/null >/dev/null
    echo -e "${BLUE}LP1: ${GREEN}Pre-Restart KDC-Script have been copied to the KDC${NC}"
    echo -e "${BLUE}LP1: ${BLUE}Running KDC-Script${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo chmod +x /tmp/kdcPreRestartScript.sh; sudo /tmp/kdcPreRestartScript.sh -g $groupCode; sudo rm /tmp/kdcPreRestartScript.sh"
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo reboot" 2> /dev/null > /dev/null
    echo -e "${BLUE}LP1: ${GREEN}Restarting KDC${NC}"
    until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
        sleep 5
    done
    scp -o StrictHostKeyChecking=no ./DomainController/kdcPostRestartScript.sh vmadmin@$kdcIP:/tmp/kdcPostRestartScript.sh 2> /dev/null >/dev/null
    echo -e "${BLUE}LP1: ${GREEN}Post-Restart KDC-Script have been copied to the KDC${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo chmod +x /tmp/kdcPostRestartScript.sh; sudo /tmp/kdcPostRestartScript.sh -g $groupCode; sudo rm /tmp/kdcPostRestartScript.sh"
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo reboot" 2> /dev/null > /dev/null
    echo -e "${BLUE}LP1: ${GREEN}Restarting KDC${NC}"
    until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
        sleep 5
    done
    result=$(ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "dig +short 'google.com'")
    if [[ $result =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] > /dev/null 2> /dev/null; then
        echo $result
        echo -e "${BLUE}LP1: ${GREEN}KDC-Script has run successfully${NC}"
    else
        echo -e "${BLUE}LP1: ${RED}Name resolution on KDC does not work. Please check DNS Settings${NC}"
    fi
else
    echo -e "${BLUE}LP1: ${RED}KDC is unreachable${NC}"
    exit
fi

# if ping -c 1 $fileServerIP &> /dev/null; then
#     scp ./FS-Scripts/fileServerPreRestartScript.sh vmadmin@$fileServerIP:~/fileServerPreRestartScript.sh
#     echo -e "${GREEN}Fileserver-Script has been copied to the Fileserver${NC}"
#     echo -e "${BLUE}Running Fileserver-Script${NC}"
#     ssh vmadmin@$fileServerIP "sudo chmod +x ./fileServerPreRestartScript.sh; sudo ./fileServerPreRestartScript.sh -g $groupCode; sudo rm ./fileServerPreRestartScript.sh; reboot"
#     echo -e "${GREEN}Restarting Fileserver${NC}"
#     until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
#         sleep 5
#     done
#     scp ./FS-Scripts/fileServerPostRestartScript.sh vmadmin@$kdcIP:~/fileServerPostRestartScript.sh
#     ssh vmadmin@$kdcIP "sudo chmod +x ./fileServerPostRestartScript.sh; sudo ./fileServerPostRestartScript.sh -g $groupCode; sudo rm ./kdcPostRestartScript.sh ; sudo reboot"
#     echo -e "${GREEN}Restarting Fileserver${NC}"
#     until ssh -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
#         sleep 5
#     done
#     if nslookup "google.com" &> /dev/null; then
#         echo -e "${GREEN}Fileserver-Script has run successfully${NC}"
#     else
#         echo -e "${RED}Name resolution on Fileserver does not work. Please check DNS Settings${NC}"
#     fi
# else
#     echo -e "${RED}Fileserver is unreachable${NC}"
#     exit
# fi