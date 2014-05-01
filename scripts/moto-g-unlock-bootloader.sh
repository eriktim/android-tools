#!/bin/bash

fastbootCheck=`fastboot devices`

if [ -z "$fastbootCheck" ]; then
	echo "Put your device in fastboot mode"
	echo "(power off, then press the power and"
	echo "  volume down buttons simultaneously)"
	exit 1
fi

unlockData=`fastboot oem get_unlock_data 2>&1`
unlockData=$(echo $unlockData | sed "s/ (bootloader) //g") # remove '(bootloader)'
unlockData=$(echo $unlockData | sed "s/\.//g") # remove (leading) dots
unlockKey=$(echo $unlockData | grep -o "^\S*") # cut at whitespace

phoneSN=$(echo $unlockKey | awk -F'#' '{print $1}')
phonePUID=$(echo $unlockKey | awk -F'#' '{print $4}')
phoneHash=$(echo $unlockKey | awk -F'#' '{print $3}')

url="https://motorola-global-portal.custhelp.com/cc/productRegistration/unlockPhone/$phoneSN/$phonePUID/$phoneHash/"

echo "First log in at https://motorola-global-portal.custhelp.com/app/standalone/bootloader/unlock-your-device-a if you havn't already"
echo ""
echo "Now visit $url"
echo ""
echo "Or use the unlock key: $unlockKey"
echo ""

fastboot reboot-bootloader

echo ""
echo -n "Enter the unlock code: "
read unlockCode
echo ""

echo "About to run"
echo "  fastboot oem unlock $unlockCode"
echo ""
echo -n "Do you wish to continue? (y/n) "
read -n 1 confirm
echo ""

if [ "$confirm" != "y" ]; then
	echo "Aborted"
	exit 1
fi

fastbootCheck=`fastboot devices`

if [ -z "$fastbootCheck" ]; then
	echo "Your device is not in fastboot mode"
	exit 1
fi

fastboot oem unlock ${unlockCode}
