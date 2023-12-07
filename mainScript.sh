#!/bin/bash

cd /tmp/m159

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\e[0;34m'
NC='\033[0m'

kdcIP='192.168.110.61'
fileServerIP='192.168.110.62'
groupCode=''
currentIP=$(hostname -I)

wait_for_ssh() {
    local host=$1
    local timeout=300
    local start_time=$(date +%s)

    until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "vmadmin@$host" true 2>/dev/null; do
        sleep 10
        local current_time=$(date +%s)
        local elapsed_time=$((current_time - start_time))

        if [ "$elapsed_time" -ge "$timeout" ]; then
            echo -e "${BLUE}LP1 | $currentIP: ${RED}Connection to $host timed out.${NC}"
            exit
        fi
    done
}

while getopts ":g:" option; do
    case $option in
        g)
            if [ ${#OPTARG} -eq 2 ] && [ -n "$OPTARG" ]; then
                groupCode=$OPTARG
            else
                echo -e "${BLUE}LP1 | $currentIP: ${RED}Invalid groupCode. It must be 2 characters long and not empty${NC}"
                exit
            fi;;
    esac
done

rm -f /home/vmadmin/.ssh/known_hosts

echo -e "${BLUE}LP1 | $currentIP: ${YELLOW}Generating new SSH Keypair${NC}"

rm -f "$HOME/.ssh/id_rsa"
rm -f "$HOME/.ssh/id_rsa.pub"

ssh-keygen -t rsa -b 2048 -f "$HOME/.ssh/id_rsa" -N "" 2> /dev/null > /dev/null

if ping -c 1 $kdcIP &> /dev/null; then
    echo -e "${BLUE}LP1 | $currentIP: ${YELLOW}Copying SSH Public Key to KDC${NC}"
    sshpass -p "sml12345" ssh-copy-id -o StrictHostKeyChecking=no vmadmin@$kdcIP 2> /dev/null > /dev/null

    scp -o StrictHostKeyChecking=no ./DomainController/kdcPreRestartScript.sh vmadmin@$kdcIP:/tmp/kdcPreRestartScript.sh 2> /dev/null > /dev/null
    echo -e "${BLUE}LP1 | $currentIP: ${BLUE}Running KDC-Script${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo chmod +x /tmp/kdcPreRestartScript.sh; sudo /tmp/kdcPreRestartScript.sh -g $groupCode; sudo rm /tmp/kdcPreRestartScript.sh"
    echo -e "${BLUE}LP1 | $currentIP: ${BLUE}Restarting KDC${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo reboot" 2> /dev/null > /dev/null
    until ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 vmadmin@$kdcIP true 2> /dev/null > /dev/null; do 
        sleep 10
    done
    scp -o StrictHostKeyChecking=no ./DomainController/kdcPostRestartScript.sh vmadmin@$kdcIP:/tmp/kdcPostRestartScript.sh 2> /dev/null > /dev/null
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo chmod +x /tmp/kdcPostRestartScript.sh; sudo /tmp/kdcPostRestartScript.sh -g $groupCode; sudo rm /tmp/kdcPostRestartScript.sh"
    echo -e "${BLUE}LP1 | $currentIP: ${BLUE}Restarting KDC${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo reboot" 2> /dev/null > /dev/null
    wait_for_ssh $kdcIP
    scp -o StrictHostKeyChecking=no ./DomainController/kdcAddUsersAndGroupsScript.sh vmadmin@$kdcIP:/tmp/kdcAddUsersAndGroupsScript.sh 2> /dev/null > /dev/null
    ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "sudo chmod +x /tmp/kdcAddUsersAndGroupsScript.sh; sudo /tmp/kdcAddUsersAndGroupsScript.sh -g $groupCode; sudo rm /tmp/kdcAddUsersAndGroupsScript.sh"
    result=$(ssh -o StrictHostKeyChecking=no vmadmin@$kdcIP "dig +short 'google.com'")
    if [[ $result =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo -e "${BLUE}LP1 | $currentIP: ${GREEN}KDC-Script has run successfully${NC}"
    else
        echo -e "${BLUE}LP1 | $currentIP: ${RED}Name resolution on KDC does not work. Please check DNS Settings${NC}"
    fi
else
    echo -e "${BLUE}LP1 | $currentIP: ${RED}KDC is unreachable${NC}"
    exit
fi

if ping -c 1 $fileServerIP &> /dev/null; then
    echo -e "${BLUE}LP1 | $currentIP: ${YELLOW}Copying SSH Public Key to File Server${NC}"
    sshpass -p "sml12345" ssh-copy-id -o StrictHostKeyChecking=no vmadmin@$fileServerIP 2> /dev/null > /dev/null

    scp -o StrictHostKeyChecking=no ./Fileserver/fileServerPreRestartScript.sh vmadmin@$fileServerIP:/tmp/fileServerPreRestartScript.sh 2> /dev/null > /dev/null
    echo -e "${BLUE}LP1 | $currentIP: ${BLUE}Running Fileserver-Script${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$fileServerIP "sudo chmod +x /tmp/fileServerPreRestartScript.sh; sudo /tmp/fileServerPreRestartScript.sh -g $groupCode; sudo rm /tmp/fileServerPreRestartScript.sh"
    echo -e "${BLUE}LP1 | $currentIP: ${BLUE}Restarting Fileserver${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$fileServerIP "sudo reboot" 2> /dev/null > /dev/null
    wait_for_ssh $fileServerIP
    scp -o StrictHostKeyChecking=no ./Fileserver/fileServerPostRestartScript.sh vmadmin@$fileServerIP:/tmp/fileServerPostRestartScript.sh 2> /dev/null > /dev/null
    echo -e "${BLUE}LP1 | $currentIP: ${BLUE}Running Fileserver-Script${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$fileServerIP "sudo chmod +x /tmp/fileServerPostRestartScript.sh; sudo /tmp/fileServerPostRestartScript.sh -g $groupCode; sudo rm /tmp/fileServerPostRestartScript.sh"
    echo -e "${BLUE}LP1 | $currentIP: ${BLUE}Restarting Fileserver${NC}"
    ssh -o StrictHostKeyChecking=no vmadmin@$fileServerIP "sudo reboot" 2> /dev/null > /dev/null
    wait_for_ssh $fileServerIP
    result=$(ssh -o StrictHostKeyChecking=no vmadmin@$fileServerIP "dig +short 'google.com'")
    if [[ $result =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo -e "${BLUE}LP1 | $currentIP: ${GREEN}Fileserver-Script has run successfully${NC}"
    else
        echo -e "${BLUE}LP1 | $currentIP: ${RED}Name resolution on Fileserver does not work. Please check DNS Settings${NC}"
    fi
else
    echo -e "${RED}Fileserver is unreachable${NC}"
    exit
fi