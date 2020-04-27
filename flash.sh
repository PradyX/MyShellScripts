#!/bin/bash
# Colors
RED="\033[1;31m" # For errors / warnings
GREEN="\033[1;32m" # For info
YELLOW="\033[1;33m" # For info
BLUE="\033[1;36m" # For info
NC="\033[0m" # reset color

# resets adb server
adb_reset()
{
  echo -e "${GREEN}Restarting ADB server${NC}"
  adb kill-server
  adb start-server
}

# waits for a recognizeable device in given state
# $1: device state
# $2: delay between scans in seconds
adb_wait()
{
  state=$1
  delay=$2
  echo -e "${GREEN}Waiting for device${NC}"
  while [[ $isDet != '0' ]]; do # wait until detected
    adb kill-server &> /dev/null
    adb start-server &> /dev/null
    adb devices | grep -w "${state}" &> /dev/null
    isDet=$?
    sleep $delay
  done
}

cd
BUILD_FILE_NAME='Derp*.zip'
ADB_DEST_FOLDER='/home/prady/platform-tools'

cd /home/prady/derpfest/out/target/product/jasmine_sprout/
adb push ${BUILD_FILE_NAME} /sdcard/xflashing

echo -en "${YELLOW}Rebooting to recovery${NC}"
adb reboot recovery


