#!/bin/bash
# Colors
RED="\033[1;31m" # For errors / warnings
GREEN="\033[1;32m" # For info
YELLOW="\033[1;33m" # For info
BLUE="\033[1;36m" # For info
NC="\033[0m" # reset color

printf "${GREEN}" 
echo "
     _  __                    _   ____            _       _   
    | |/ /___ _ __ _ __   ___| | / ___|  ___ _ __(_)_ __ | |_ 
    | ' // _ \ '__| '_ \ / _ \ | \___ \ / __| '__| | '_ \| __|
    | . \  __/ |  | | | |  __/ |  ___) | (__| |  | | |_) | |_ 
    |_|\_\___|_|  |_| |_|\___|_| |____/ \___|_|  |_| .__/ \__|
                                               |_|        
"
echo -e "${GREEN}                      by @Prady${NC}"

cd /home/prady/derpfest/kernel/xiaomi/sdm660
export KERNEL_USE_CCACHE=1
export USE_CCACHE=1
export CCACHE_DIR=/home/prady/.ccache
export KBUILD_BUILD_USER=Prady;
export KBUILD_BUILD_HOST=potato-pc;

# Examine our compilation threads
# 2x of our available CPUs
# Kanged from @raphielscape
CPU="$(grep -c '^processor' /proc/cpuinfo)"
JOBS="$(( CPU * 2 ))"

# function
build(){
    make O=out ARCH=arm64 wayne_defconfig
    time (
        PATH=/home/prady/proton-clang/bin:${PATH} \
        make -j"${JOBS}" O=out \
                      ARCH=arm64 \
                      CC=ccache \
                      CC=clang \
                      AR=llvm-ar \
                      NM=llvm-nm \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      STRIP=llvm-strip \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                      CROSS_COMPILE=aarch64-linux-gnu- |tee ../compile.log ;
    );
} 

zip(){
    echo -e "${RED}Zip it?${NC} ${BLUE}{y/n}${NC}"
    read base
    if [[ $base = 'y' ]];then
    pwd && cd /home/prady/MyScripts && ./zip.sh
    else
    exit 
    fi
}

echo " "
echo -e " ${GREEN}1${NC} ${BLUE}Start building? ${NC}"
echo -e " ${GREEN}2${NC} ${BLUE}Open out dir ${NC}"
echo -e " ${GREEN}3${NC} ${BLUE}Flash karamel${NC}"
echo -e " ${GREEN}4${NC} ${BLUE}Update Wireguard${NC}"

read base

if [ $base = 1 ]
then
echo -e "${GREEN}Starting build...${NC}"
    echo -en "${YELLOW}MAKE CLEAN? y/[${BLUE}n${YELLOW}]: ${NC}"
    read clean
    if [[ $clean = 'y' ]]; then
        make clean && make mrproper O=out
        build
        zip
    else
        build
        zip
    fi
echo -e "${YELLOW}Done!${NC}"
fi

if [ $base = 2 ]
then
nemo out/arch/arm64/boot
fi

if [ $base = 4 ]
then
echo "Opening wireguard webpage..."
python -mwebbrowser https://git.zx2c4.com/wireguard-linux-compat/

USER_AGENT="WireGuard-AndroidROMBuild/0.3 ($(uname -a))"

read -p "Enter version: " VERSION

rm -rf net/wireguard
mkdir -p net/wireguard
curl -A "$USER_AGENT" -LsS --connect-timeout 30 "https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-$VERSION.tar.xz" | tar -C "net/wireguard" -xJf - --strip-components=2 "wireguard-linux-compat-$VERSION/src"
sed -i 's/tristate/bool/;s/default m/default y/;' net/wireguard/Kconfig
git add net/wireguard
git commit -s -m "net: wireguard: Update to $VERSION"

fi
# if [ $base = 1 ]
# then
# echo -e "${GREEN}Starting build...${NC}"
# time (
#     PATH=/home/prady/clang/bin:/home/prady/aarch64-linux-android-4.9/bin:${PATH} \
#     make -j8 O=out \
#                       ARCH=arm64 \
#                       CC=ccache \
#                       CC=clang \
#                       CLANG_TRIPLE=aarch64-linux-gnu- \
#                       CROSS_COMPILE=aarch64-linux-android- |tee ../compile.log ;

#                       echo -e "${RED}Zip it?${NC}"
#                       echo -e "   ${GREEN}0${NC} ${BLUE}NO${NC}"
#                       echo -e "   ${GREEN}1${NC} ${BLUE}YES${NC}"
#                       read base
#                       if [ $base = 1 ]
#                       then
#                       pwd && cd /home/prady/MyScripts && ./zip.sh
#                       fi
                      
#                       if [ $base = 0 ]
#                       then
#                       exit 
#                       fi
# )
# echo -e "${YELLOW}Done!${NC}"
# fi