#!/bin/sh

# Android CAcert Class 1 & 3 Root Certificate Pusher
# Code by Erik Timmers <etimmers@gmail.com>
# Version 1.0 - 2013/07/31
# Usage: ./android-cacert.sh [<serial-number>]

ADB_BIN="adb"
if [ $# -le 1 ]; then
    ADB_DEVICE=`$ADB_BIN devices | head -n2 | tail -n1 | awk '{print $1}'`
else
    ADB_DEVICE=$1
fi

if [ "$ADB_DEVICE" = "" ] || [ "$ADB_DEVICE" = "*" ]; then
    echo "No device present"
    exit 1
fi

ADB_ARGS="-s $ADB_DEVICE"
ADB="$ADB_BIN $ADB_ARGS"

ANDROID_VERSION=`$ADB shell getprop ro.build.version.release`
IFS_BAK=$IFS
export IFS="."
for V in $ANDROID_VERSION; do
    if [ $V -lt 4 ]; then
        echo "Your device must run Android 4.0.4+ only"
        exit 1
    fi
    break
done
export IFS=$IFS_BAK

echo "Using device '$ADB_DEVICE'"

TEST_CMD=`$ADB shell "echo -n 'testing'"`

if [ "$TEST_CMD" != "testing" ]; then
    echo "Failed connecting to '$ADB_DEVICE'"
    exit 1
fi

ADB_ROOT_TEST=`$ADB shell 'getprop service.adb.root'`

if [ "$ADB_ROOT_TEST" -ne "$ADB_ROOT_TEST" ]; then
    ADB_ROOT_TEST="0"
fi

if [ "$ADB_ROOT_TEST" -ne 1 ]; then
    echo "Restarting adb as root, wait for 3 seconds..."
    $ADB root > /dev/null
    sleep 3

    ADB_ROOT_TEST=`$ADB shell 'getprop service.adb.root'`

    if [ "$ADB_ROOT_TEST" -ne "$ADB_ROOT_TEST" ]; then
        ADB_ROOT_TEST="0"
    fi
    
    if [ "$ADB_ROOT_TEST" -ne 1 ]; then
        echo "Root access not granted. Please verify that:"
	echo "* your device is rooted"
	echo "* adb is running again"
	echo "* your device accepted the fingerprint of your computer"
	echo "* adb root access is enabled in the developer options"
        exit 1
    fi
fi

CERT_ROOT="root.crt"
CERT_CLASS3="class3.crt"

wget -N -q https://www.cacert.org/certs/$CERT_ROOT
wget -N -q https://www.cacert.org/certs/$CERT_CLASS3

if [ -f "$CERT_ROOT" ] && [ -f "$CERT_CLASS3" ]; then

    echo "Please verify the following fingerprints match those on https://www.cacert.org/index.php?id=3 and type 'verified' to continue."
    echo "Class 1 PKI Key:"
    echo `openssl x509 -in $CERT_ROOT -sha1 -noout -fingerprint`
    echo "Class 3 PKI Key:"
    echo `openssl x509 -in $CERT_CLASS3 -sha1 -noout -fingerprint`
    echo -n "> "
    read VERIFIED

    if [ "$VERIFIED" = "verified" ]; then

        HASH_ROOT=`openssl x509 -noout -subject_hash_old -in $CERT_ROOT`
        HASH_CLASS3=`openssl x509 -noout -subject_hash_old -in $CERT_CLASS3`
        mv $CERT_ROOT $HASH_ROOT.0
        mv $CERT_CLASS3 $HASH_CLASS3.0
	CERT_ROOT=$HASH_ROOT.0
	CERT_CLASS3=$HASH_CLASS3.0

        REMOTE_DIR="/sdcard/"

        echo "Push certificates"
        $ADB push $CERT_ROOT $REMOTE_DIR
        $ADB push $CERT_CLASS3 $REMOTE_DIR

        echo "Add certificates to system files"
        $ADB remount -o rw,remount /system > /dev/null
        $ADB shell 'cp '$REMOTE_DIR$CERT_ROOT' /etc/security/cacerts/'
        $ADB shell 'cp '$REMOTE_DIR$CERT_CLASS3' /etc/security/cacerts/'
        $ADB shell 'chmod 644 /etc/security/cacerts/'$CERT_ROOT
        $ADB shell 'chmod 644 /etc/security/cacerts/'$CERT_CLASS3
        $ADB remount -o ro,remount /system > /dev/null
        $ADB shell 'rm '$REMOTE_DIR$CERT_ROOT
        $ADB shell 'rm '$REMOTE_DIR$CERT_CLASS3

        echo "Installed CAcert certificates"
    else
        echo "Aborted installing CAcert certificates"
    fi
    rm $CERT_ROOT $CERT_CLASS3
else
    echo "Failed downloading CAcert certificates"
fi

echo "Restarting adb as user"
$ADB shell 'setprop service.adb.root 0'
$ADB shell 'restart adbd'

