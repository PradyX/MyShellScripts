#!/bin/bash

# Colors
RED="\033[1;31m" # For errors / warnings
GREEN="\033[1;32m" # For info
YELLOW="\033[1;33m" # For info
BLUE="\033[1;36m" # For info
NC="\033[0m" # reset color

# printf "${GREEN}" 
# echo "
#      ____        _ _     _   ____            _       _   
#     | __ ) _   _(_) | __| | / ___|  ___ _ __(_)_ __ | |_ 
#     |  _ \| | | | | |/ _` | \___ \ / __| '__| | '_ \| __|
#     | |_) | |_| | | | (_| |  ___) | (__| |  | | |_) | |_ 
#     |____/ \__,_|_|_|\__,_| |____/ \___|_|  |_| .__/ \__|
#                                               |_|        

# "
# echo "                      by @Prady"
# printf "${NC}"
printf "${GREEN}" 
figlet "    Build Script"
echo "                      by @Prady"
printf "${NC}"

#cd /home/prady/derpfest
export USE_CCACHE=1
export CCACHE_EXEC=$(which ccache)

BUILD_FILE_NAME='C*.zip'
#SCRIPT=/home/prady/MyScripts
PRODUCT_PATH=out/target/product/jasmine_sprout
BUILD_NAME=$(find C*.zip)
ROM_NAME=cygnus
ROM_SED=s/lucid/${ROM_NAME}/g
ROM_MAKE=mka cygnus

build_low_ram(){
    time (. build/envsetup.sh && lunch ${ROM_NAME}_jasmine_sprout-userdebug && mka api-stubs-docs && mka hiddenapi-lists-docs && mka system-api-stubs-docs && mka test-api-stubs-docs && ${ROM_MAKE}  | tee log.txt);
}

build_normal(){
    time (. build/envsetup.sh && lunch ${ROM_NAME}_jasmine_sprout-userdebug &&  ${ROM_MAKE} | tee log.txt);
}

echo ""
echo -e "${YELLOW}Choose any Option :${NC}"
echo -e " ${GREEN}1${NC} ${BLUE}Sync sauce${NC}"
echo -e " ${GREEN}2${NC} ${BLUE}Start building rom${NC}"
echo -e " ${GREEN}3${NC} ${BLUE}Start CLEANUP${NC}"
echo -e " ${GREEN}4${NC} ${BLUE}CD target device folder${NC}"
echo -e " ${GREEN}5${NC} ${BLUE}Clone device source${NC}"
echo -e " ${GREEN}6${NC} ${BLUE}Edit device tree${NC}"
echo -e " ${GREEN}7${NC} ${BLUE}Upload Build Gdrive${NC}"
read base

if [ $base = 1 ]
then
echo -e "${GREEN}Starting Sync...${NC}"
#time repo sync -j$ (nproc --all) --force-sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-broken
time repo sync -j2 --force-sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-broken
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 2 ]
then
    echo -e "${YELLOW}Low Ram Hack?${NC} ${RED}{y/n}${NC}"
    read base
    if [[ $base = 'y' ]];then
    echo -e "${GREEN}Starting Build...${NC}"
    build_low_ram
    else
    echo -e "${GREEN}Starting Build...${NC}"
    build_normal 
    fi
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 3 ]
then
    echo -e "${YELLOW}Full clean?${NC} ${RED}{y/n}${NC}"
    read base
    if [[ $base = 'y' ]];then
    echo -e "${GREEN}Starting full clean...${NC}"
    time make clean && make clobber
    else
    echo -e "${GREEN}Starting partial clean...${NC}"
    time make installclean
    fi
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 4 ]
then
cd ${PRODUCT_PATH}
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 5 ]
then
git clone https://github.com/DerpFest-Devices/android_device_xiaomi_jasmine_sprout.git -b lucid "device/xiaomi/jasmine_sprout"
git clone https://github.com/DerpFest-Devices/android_device_xiaomi_sdm660-common.git "device/xiaomi/sdm660-common"
git clone https://github.com/xiaomi-sdm660/android_vendor_xiaomi_wayne.git "vendor/xiaomi/wayne"
git clone https://github.com/xiaomi-sdm660/android_vendor_xiaomi_sdm660-common.git "vendor/xiaomi/sdm660-common"
git clone https://github.com/PradyX/unified_kernel_sdm660.git -b master "kernel/xiaomi/sdm660"
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 6 ]
then
cd device/xiaomi/jasmine_sprout
mv lucid_jasmine_sprout.mk ${ROM_NAME}_jasmine_sprout.mk
sed -i ${ROM_SED} ${ROM_NAME}_jasmine_sprout.mk
sed -i ${ROM_SED} AndroidProducts.mk
fi

if [ $base = 7 ]
then
cd ${PRODUCT_PATH}
pwd
echo "Uploading ${BUILD_NAME} to GDRIVE"
rclone copy --retries 3 ${BUILD_FILE_NAME} "gdrive:mia2/rclone" 
fi