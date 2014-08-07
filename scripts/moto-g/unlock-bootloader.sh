#!/bin/sh

fastbootCheck=$(fastboot devices)

if [ -z "$fastbootCheck" ]; then
	echo "Put your device in fastboot mode (i.e. power off, and then"
	echo "press the power and volume down buttons simultaneously)."
	exit 1
fi

unlockData=$(fastboot oem get_unlock_data 2>&1)
unlockKey=$(echo ${unlockData} | sed "s/ (bootloader) //g" | sed "s/\.//g" | grep -o "^\S*")

phoneSN=$(echo ${unlockKey} | awk -F'#' '{print $1}')
phonePUID=$(echo ${unlockKey} | awk -F'#' '{print $4}')
phoneHash=$(echo ${unlockKey} | awk -F'#' '{print $3}')

url="https://motorola-global-portal.custhelp.com/cc/productRegistration/unlockPhone/$phoneSN/$phonePUID/$phoneHash/"

echo "First log in at the Motorola website if you have not already:"
echo ""
echo "  https://motorola-global-portal.custhelp.com/app/standalone/bootloader/unlock-your-device-a"
echo ""
echo "Now visit:"
echo ""
echo "  $url"
echo ""
echo "Or use the unlock key: $unlockKey"
echo ""

fastboot reboot-bootloader > /dev/null 2>&1

echo ""
echo -n "Enter the unlock code: "
read unlockCode
echo ""
echo "About to run"
echo ""
echo "  $ fastboot oem unlock $unlockCode"
echo ""
echo -n "Do you wish to continue? (y/n) "
read confirm
echo ""

if [ "$confirm" != "y" ]; then
	echo "Aborted"
	exit 1
fi

fastbootCheck=$(fastboot devices)

if [ -z "$fastbootCheck" ]; then
	echo "Your device is not in fastboot mode"
	exit 1
fi

echo "Wait for your device to fully reboot"
echo ""

fastboot oem unlock ${unlockCode} > /dev/null 2>&1
