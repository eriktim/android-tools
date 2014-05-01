#!/bin/sh

fastbootCheck=`fastboot devices`

if [ -z "$fastbootCheck" ]; then
	echo "Put your device in fastboot mode"
	echo "(power off, then press the power and"
	echo "  volume down buttons simultaneously)"
	exit
fi

unlockData=`fastboot oem get_unlock_data 2>&1`
unlockData=$(echo $unlockData | sed "s/ (bootloader) //g") # remove '(bootloader)'
unlockData=$(echo $unlockData | sed "s/\.//g") # remove (leading) dots
unlockKey=$(echo $unlockData | grep -o "^\S*") # cut at whitespace

echo "Unlock key: $unlockKey"
echo ""

phoneSN=$(echo $unlockKey | awk -F'#' '{print $1}')
phonePUID=$(echo $unlockKey | awk -F'#' '{print $4}')
phoneHash=$(echo $unlockKey | awk -F'#' '{print $3}')

url="https://motorola-global-portal.custhelp.com/cc/productRegistration/unlockPhone/$phoneSN/$phonePUID/$phoneHash/"

echo $url
