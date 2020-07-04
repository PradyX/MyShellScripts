#!/bin/bash
# Colors
RED="\033[1;31m" # For errors / warnings
GREEN="\033[1;32m" # For info
YELLOW="\033[1;33m" # For info
BLUE="\033[1;36m" # For info
NC="\033[0m" # reset color

wifi(){
    ip link show
    cd /etc/netplan/
    ls -l
    echo "Backup *cloud-init.yaml file"
    sudo cp 50-cloud-init.yaml 50-cloud-init.yaml.bak
    echo "Delete *cloud-init.yaml"
    sudo rm -rf 50-cloud-init.yaml
    cd && cd sc/pi 
    sudo cp -r 50-cloud-init.yaml /etc/netplan/
}

echo ""
echo -e "${YELLOW}Choose any Option :${NC}"
echo -e " ${GREEN}1${NC} ${BLUE}Add wifi${NC}"

read base

if [ $base = 1 ]
then
echo -e "${GREEN}Setting up wifi...${NC}"
wifi
sudo netplan --debug try
sudo netplan --debug generate
echo -e "${YELLOW}Apply settings & reboot?${NC} ${RED}{y/n}${NC}"
        read base
        if [[ $base = 'y' ]];then
        sudo netplan --debug apply
        sudo reboot
        else
        exit
        fi
echo -e "${YELLOW}Done!${NC}"
fi