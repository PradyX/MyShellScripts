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

cd /home/prady/derpfest
export USE_CCACHE=1
export CCACHE_EXEC=$(which ccache)

BUILD_FILE_NAME='Derp*.zip'
SCRIPT=/home/prady/MyScripts
PRODUCT_PATH=/home/prady/derpfest/out/target/product/jasmine_sprout/
BUILD_NAME=$(find D*.zip)

build_low_ram(){
    cd /home/prady/derpfest
    time (. build/envsetup.sh && lunch derp_jasmine_sprout-userdebug && mka api-stubs-docs && mka hiddenapi-lists-docs && mka system-api-stubs-docs && mka test-api-stubs-docs && mka kronic ) 2>&1 | tee output.log 
}

build_normal(){
    cd /home/prady/derpfest
    time (. build/envsetup.sh && lunch derp_jasmine_sprout-userdebug && mka kronic) 2>&1 | tee output.log 
}

notif_start(){
    telegram-send --format markdown "*DerpFest* build started for *jasmeme* at *$(date +%X)*"
}
notif_done(){
    #telegram-send --format markdown "*DerpFest* build completed for *jasmeme* at *$(date +%X)*"
    telegram-send --file output.log --caption "DerpFest build completed for jasmeme at $(date +%X)"
}
notif_upload_sf(){
    telegram-send  "Uploading completed to SF at $(date +%X), visit https://sourceforge.net/projects/derpfest/files/jasmine_sprout/"
    echo "Uploading ${BUILD_NAME} finished."
}
notif_upload_gdrive(){
    telegram-send --format markdown "Uploading completed to *GDRIVE* at *$(date +%X)*, visit https://drive.google.com/open?id=1MfBUuktApHZqvtd2qfbcSUNmmmfw4Q3L"
    echo "Uploading ${BUILD_NAME} finished."
}

echo ""
echo -e "${YELLOW}Choose any Option :${NC}"
echo -e " ${GREEN}1${NC} ${BLUE}Re-sync sauce${NC}"
echo -e " ${GREEN}2${NC} ${BLUE}Start building rom${NC}"
echo -e " ${GREEN}3${NC} ${BLUE}Start CLEANUP${NC}"
echo -e " ${GREEN}4${NC} ${BLUE}Open target device folder${NC}"
echo -e " ${GREEN}5${NC} ${BLUE}Start fetch script${NC}"
echo -e " ${GREEN}6${NC} ${BLUE}Start kernel script${NC}"
echo -e " ${GREEN}7${NC} ${BLUE}Flash karamel${NC}"
echo -e " ${GREEN}8${NC} ${BLUE}Upload Build [SF/Gdrive]${NC}"

read base

if [ $base = 1 ]
then
echo -e "${GREEN}Starting Sync...${NC}"
#time repo sync -j$(nproc --all) --force-sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-broken
time repo sync -j4 --force-sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-broken
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 2 ]
then

building(){
        echo -e "${YELLOW}Low Ram Hack?${NC} ${RED}{y/n}${NC}"
        read base
        if [[ $base = 'y' ]];then
        echo -e "${GREEN}Starting Build...${NC}"
        notif_start
        build_low_ram
        else
        echo -e "${GREEN}Starting Build...${NC}"
        notif_start
        build_normal 
        fi
    }

    echo -e "${YELLOW}Wipe product DIR?${NC} ${RED}{y/n}${NC}"
    read base
    if [[ $base = 'y' ]];then
    echo -e "${YELLOW}Wiping product DIR${NC}"
    rm -rf /home/prady/derpfest/out/target/product/jasmine_sprout
    echo -e "${GREEN}Done!${NC}"
    building
    else
    building
    fi
echo -e "${GREEN}Done!${NC}"
notif_done
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
nemo out/target/product/jasmine_sprout
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 5 ]
then
cd ${SCRIPT} && ./fetch.sh
fi

if [ $base = 6 ]
then
echo -e "${GREEN}Starting Script...${NC}"
cd ${SCRIPT} && ./kernel.sh
fi

if [ $base = 7 ]
then
cd ${SCRIPT} && ./flash.sh
fi

if [ $base = 8 ]
then
echo -e "${YELLOW}Upload to SF?${NC} ${RED}{y/n}${NC}"
    read base
    if [[ $base = 'y' ]];then
    echo "Uploading ${BUILD_NAME} to SF"
    cd ${SCRIPT} && ./telegram "Uploading build to SF started at $(date +%X)"
    cd ${PRODUCT_PATH}
    pwd
    echo "Sftp ${BUILD_NAME} [y/n]"
    read base
    if [[ $base = 'y' ]];then
    sftp prady@web.sourceforge.net
    # cd /home/frs/project/derpfest/jasmine_sprout
    # put ${BUILD_FILE_NAME}
    else
    scp ${BUILD_FILE_NAME} prady@frs.sourceforge.net:/home/frs/project/derpfest/jasmine_sprout
    fi
    notif_upload_sf

    else

    telegram-send "Uploading build to GDRIVE started at $(date +%X)"
    cd ${PRODUCT_PATH}
    pwd
    echo "Uploading ${BUILD_NAME} to GDRIVE"
    rclone copy --update --verbose --checkers 8 --retries 3 --low-level-retries 10 --stats 1s ${BUILD_FILE_NAME} "gdrive:mia2/rclone" 
    notif_upload_gdrive
    fi
fi