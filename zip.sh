#!/bin/bash
# Colors
RED="\033[1;31m" # For errors / warnings
GREEN="\033[1;32m" # For info
YELLOW="\033[1;33m" # For info
BLUE="\033[1;36m" # For info
NC="\033[0m" # reset color

printf "${GREEN}" 

echo "Entering out dir"
cd /home/prady/derpfest/kernel/xiaomi/sdm660/out/arch/arm64/boot

echo "Copying dtb"
cp -R Image.gz-dtb /home/prady/kernel-zip

echo "Zipping"
pwd
cd /home/prady/kernel-zip
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
cd /home/prady/MyScripts && ./telegram -f /home/prady/kernel-zip/derpfest_stock_eas_kernel.zip "Compilation done for device jasmine_sprout at $(date +%Y%m%d-%H%M)! Visit https://bit.ly/2xEbN1R for changelogs."
fi

if [ $base = 0 ]
then
nemo /home/prady/kernel-zip/
exit 
fi

 
