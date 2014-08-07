#!/bin/sh

fastbootCheck=$(fastboot devices)

if [ -z "$fastbootCheck" ]; then
	echo "Put your device in fastboot mode (i.e. power off, and then"
	echo "press the power and volume down buttons simultaneously)."
	exit 1
fi

fastbootBuildVersion=$(fastboot getvar ro.build.version.full 2>&1)
buildVersion=$(echo $fastbootBuildVersion | sed 's/ /\n/g' | \
        sed -n '/ro\.build.version.full\[[0-9]\+\]/{n;p}' | tr -d '\n')
buildVersionRef="Blur_Version.210.12.40.falcon_umts.EURetail.en.EU"

if [ "$buildVersion" != "$buildVersionRef" ]; then
    echo "Found build version:    $buildVersion"
    echo "Expected build version: $buildVersionRef"
    exit 1
fi

echo "Flash recovery-clockwork-6.0.4.7-falcon.img"
echo ""

fastboot flash recovery recovery-clockwork-6.0.4.7-falcon.img > /dev/null 2>&1

echo "Waiting for YOU to enter recovery..."
echo ""

adbDevice=1
while [ $adbDevice -ne 0 ]
do
    sleep 3
    adb devices | grep -q "recovery"
    adbDevice=$?
done

echo "Flash philz_touch_6.13.2-xt1032.zip"
echo "Waiting for YOU to toggle sideload:"
echo "  * Install zip"
echo "  * Install zip from sideload"
echo ""

adbSideload=0
while [ $adbSideload -eq 0 ]
do
    sleep 3
    adb sideload philz_touch_6.13.2-xt1032.zip 2>&1 | grep -q "error: closed"
    adbSideload=$?
done

sleep 12

echo "Flash supersu.motog.zip"
echo "Waiting for YOU to toggle sideload:"
echo "  * Install zip"
echo "  * Install zip from sideload"
echo ""

adbSideload=0
while [ $adbSideload -eq 0 ]
do
    sleep 3
    adb sideload supersu.motog.zip 2>&1 | grep -q "error: closed"
    adbSideload=$?
done

sleep 20

echo "Rebooting into recovery..."
echo ""

adb reboot recovery

adbDevice=1
while [ $adbDevice -ne 0 ]
do
    sleep 3
    adb devices | grep -q "recovery"
    adbDevice=$?
done

echo "Entered recovery"
echo "Hold on..."
echo ""

sleep 3

echo "Copying backup data..."
echo "This may take a while."

adb shell mount /data
adb push clockworkmod /sdcard/clockworkmod > /dev/null 2>&1
adb shell umount /data

echo "Done."
echo ""

sleep 1

echo "Restore the backup:"
echo "  * Backup and Restore"
echo "  * Restore from /sdcard"
echo "  * 2014-03-27.21.32.17_KLB20.9-1.10-1.24-1.1"
echo "  * Yes - Restore"
echo ""
echo "I'll come back in 60 seconds..."
echo ""

sleep 60

echo "Reboot to bootloader:"
echo "  * Power Options"
echo "  * Reboot to Bootloader"
echo ""
echo "Waiting for YOU to reboot to bootloader..."

sleep 3

while [ -z $(fastboot devices) ]
do
    sleep 3
done

echo "Flashing bootlogo..."

fastboot flash logo logo-custom.bin > /dev/null 2>&1

echo "Reboot..."

fastboot reboot > /dev/null 2>&1

echo "All done!"

