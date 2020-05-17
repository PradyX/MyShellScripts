#!/bin/bash
# Colors
RED="\033[1;31m" # For errors / warnings
GREEN="\033[1;32m" # For info
YELLOW="\033[1;33m" # For info
BLUE="\033[1;36m" # For info
NC="\033[0m" # reset color

printf "${GREEN}" 

SCRIPT=/home/prady/MyScripts
KERNEL_OUT_DIR=/home/prady/derpfest/kernel/xiaomi/sdm660/out/arch/arm64/boot
KERNEL_ZIP=/home/prady/kernel-zip

notif_upload(){
    cd ${SCRIPT} && ./telegram -f ${KERNEL_ZIP}/derpfest_stock_eas_kernel.zip "Compilation done for device jasmine_sprout at $(date +%X) ! Visit https://github.com/PradyX/unified_kernel_sdm660/commits/master for changelogs."
}

echo "Entering out dir"
cd ${KERNEL_OUT_DIR}

echo "Copying dtb"
cp -R Image.gz-dtb ${KERNEL_ZIP}

echo "Zipping"
pwd
cd ${KERNEL_ZIP}
zip -r -D derpfest_stock_eas_kernel.zip *
printf "${NC}" 


printf "${BLUE}"
echo -e "${RED}Upload it to telegram?${NC}"
echo -e "${GREEN}0${NC} ${BLUE}NO${NC}"
echo -e "${GREEN}1${NC} ${BLUE}YES${NC}"
read base
if [ $base = 1 ]
then
echo "Uploading"
pwd 
notif_upload
fi

if [ $base = 0 ]
then
nemo ${KERNEL_ZIP}
exit 
fi

 
