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

build_low_ram(){
    cd /home/prady/derpfest
    time (. build/envsetup.sh && lunch derp_jasmine_sprout-userdebug && mka api-stubs-docs && mka hiddenapi-lists-docs && mka system-api-stubs-docs && mka test-api-stubs-docs && mka kronic );
}

build_normal(){
    cd /home/prady/derpfest
    time (. build/envsetup.sh && lunch derp_jasmine_sprout-userdebug && mka kronic);
}

notif_start(){
    cd /home/prady/MyScripts && ./telegram "DerpFest build started for jasmeme at $(date +%Y%m%d-%H%M)"
}
notif_done(){
    cd /home/prady/MyScripts && ./telegram "DerpFest build completed for jasmeme at $(date +%Y%m%d-%H%M)"
}

echo ""
echo -e "${YELLOW}Choose any Option :${NC}"
echo -e " ${GREEN}1${NC} ${BLUE}Re-sync sauce${NC}"
echo -e " ${GREEN}2${NC} ${BLUE}Start building rom${NC}"
echo -e " ${GREEN}3${NC} ${BLUE}MAKE CLEAN${NC}"
echo -e " ${GREEN}4${NC} ${BLUE}MAKE INSTALLCLEAN${NC}"
echo -e " ${GREEN}5${NC} ${BLUE}Open target device folder${NC}"
echo -e " ${GREEN}6${NC} ${BLUE}Start fetch script${NC}"
echo -e " ${GREEN}7${NC} ${BLUE}Start kernel script${NC}"
echo -e " ${GREEN}8${NC} ${BLUE}Flash karamel${NC}"

read base

if [ $base = 1 ]
then
echo -e "${GREEN}Starting Sync...${NC}"
#time repo sync -j$ (nproc --all) --force-sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-broken
time repo sync -j4 --force-sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-broken
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 2 ]
then
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
echo -e "${YELLOW}Done!${NC}"
notif_done
fi

if [ $base = 3 ]
then
echo -e "${GREEN}Starting clean...${NC}"
time make clean && make clobber
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 4 ]
then
echo -e "${GREEN}Starting clean...${NC}"
time make installclean
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 5 ]
then
nemo out/target/product/jasmine_sprout
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 6 ]
then
cd /home/prady/MyScripts && ./fetch.sh
fi

if [ $base = 7 ]
then
echo -e "${GREEN}Starting Script...${NC}"
cd /home/prady/MyScripts && ./kernel.sh
fi

if [ $base = 8 ]
then
cd /home/prady/MyScripts && ./flash.sh
fi
