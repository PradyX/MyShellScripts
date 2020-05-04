#!/bin/bash
# Colors
RED="\033[1;31m" # For errors / warnings
GREEN="\033[1;32m" # For info
YELLOW="\033[1;33m" # For info
BLUE="\033[1;36m" # For info
NC="\033[0m" # reset color

cd
BUILD_FILE_NAME='Derp*.zip'
ADB_DEST_FOLDER='/home/prady/platform-tools'

notif_adb_push(){
    cd /home/prady/MyScripts && ./telegram "Pushing zip to /sdcard/flashing"
}
notif_adb_reb(){
    echo -e "${YELLOW}Rebooting to Recovery${NC}"
    cd /home/prady/MyScripts && ./telegram "Rebooting to Recovery"
}
notif_adb_fl(){
    echo -e "${YELLOW}Flashing to Inactive Slot${NC}"
    cd /home/prady/MyScripts && ./telegram "Flashing to Inactive Slot"
}

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

notif_adb_reb
adb reboot recovery

notif_adb_push
cd /home/prady/derpfest/out/target/product/jasmine_sprout/
pwd
adb push ${BUILD_FILE_NAME} /sdcard/xflashing