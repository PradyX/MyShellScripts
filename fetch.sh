#!/bin/bash

# Colors
RED="\033[1;31m" # For errors / warnings
GREEN="\033[1;32m" # For info
YELLOW="\033[1;33m" # For info
BLUE="\033[1;36m" # For info
NC="\033[0m" # reset color

cd /home/prady/derpfest

echo -e "${GREEN}
     _____    _       _       ____            _       _   
    |  ___|__| |_ ___| |__   / ___|  ___ _ __(_)_ __ | |_ 
    | |_ / _ \ __/ __| '_ \  \___ \ / __| '__| | '_ \| __|
    |  _|  __/ || (__| | | |  ___) | (__| |  | | |_) | |_ 
    |_|  \___|\__\___|_| |_| |____/ \___|_|  |_| .__/ \__|
                                               |_|        
    ${NC}"
echo -e "${GREEN}                      by @Prady${NC}"

echo ""
echo -e "${YELLOW}Choose any Option :${NC}"
echo -e "${GREEN}1${NC} ${BLUE}Fetch android_device_xiaomi_sdm660-common${NC}   cr-8.0"
echo -e "${GREEN}2${NC} ${BLUE}Fetch android_device_xiaomi_jasmine_sprout${NC}  cr-8.0"
echo -e "${GREEN}3${NC} ${BLUE}Fetch android_vendor_xiaomi_sdm660-common${NC}   cr-8.0-eas"
echo -e "${GREEN}4${NC} ${BLUE}Fetch android_vendor_xiaomi_wayne${NC}   lineage-17.0"
echo -e "${GREEN}5${NC} ${BLUE}Fetch android_kernel_xiaomi_sdm660${NC}  kernel.lnx.4.4.r38-rel-wifi"
echo -e "${GREEN}6${NC} ${BLUE}Fetch PradyX/android_kernel_xiaomi_sdm660${NC}   eas"

read base

if [ $base = 1 ]
then
echo -e "${GREEN}Starting fetch...${NC}"
cd device/xiaomi/sdm660-common && git fetch https://github.com/xiaomi-sdm660/android_device_xiaomi_sdm660-common.git cr-8.0
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 2 ]
then
echo -e "${GREEN}Starting fetch...${NC}"
cd device/xiaomi/jasmine_sprout && git fetch https://github.com/xiaomi-sdm660/android_device_xiaomi_jasmine_sprout.git cr-8.0
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 3 ]
then
echo -e "${GREEN}Starting fetch...${NC}"
cd vendor/xiaomi/sdm660-common && git fetch https://github.com/xiaomi-sdm660/android_vendor_xiaomi_sdm660-common.git cr-8.0-eas
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 4 ]
then
echo -e "${GREEN}Starting fetch...${NC}"
cd vendor/xiaomi/wayne && git fetch https://github.com/xiaomi-sdm660/android_vendor_xiaomi_wayne.git lineage-17.0
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 5 ]
then
echo -e "${GREEN}Starting fetch...${NC}"
cd kernel/xiaomi/sdm660 && git fetch https://github.com/xiaomi-sdm660/android_kernel_xiaomi_sdm660.git kernel.lnx.4.4.r38-rel-wifi
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 6 ]
then
echo -e "${GREEN}Starting fetch...${NC}"
cd kernel/xiaomi/sdm660 && git fetch https://github.com/PradyX/android_kernel_xiaomi_sdm660.git eas
echo -e "${YELLOW}Done!${NC}"
fi