# Hide carrier label

*debian* | *motorola moto g* | *4.4.2 kitkat*

Firstly, pull `SystemUI.apk` and the device-specific framework from your device.

    $ adb shell
    $ cp /system/priv-app/SystemUI.apk /sdcard/
    $ cp /system/framework/framework-res.apk /sdcard/
    $ exit
    $ adb pull /sdcard/SystemUI.apk .
    $ adb pull /sdcard/framework-res.apk .

Next, download `apktool_2.0.0b8.jar` from \[1\], set the correct framework and decompile\[2\] `SystemUI.apk`.

    $ wget http://miui.connortumbleson.com/other/apktool/test_versions/apktool_2.0.0b8.jar
    $ java -jar apktool_2.0.0b8.jar if framework-res.apk
    $ java -jar apktool_2.0.0b8.jar d SystemUI.apk

Now modify the package\[3\]: search for `onsText` and update the `TextView`'s appropriate attribute to `android:maxLength="0"`.

    $ vim SystemUI/res/layout/status_bar.xml

Recompile the modified version while preserving the signature (using `-c`), which will allow you to replace the APK later on.

    $ java -jar apktool_2.0.0b8.jar b SystemUI -c

Finally, push the modified `SystemUI.apk` to the device and install it.

    $ adb push SystemUI/dist/SystemUI.apk /sdcard/SystemUI.apk
    $ adb shell
    $ su
    # mount -o remount,rw /system
    # cp /system/priv-app/SystemUI.apk /system/priv-app/SystemUI.apk.BAK
    # cp /system/priv-app/SystemUI.odex /system/priv-app/SystemUI.odex.BAK
    # cp /sdcard/SystemUI.apk /system/priv-app/SystemUI.apk
    # chmod 644 /system/priv-app/SystemUI.apk
    # mount -o remount,ro /system
    # reboot

\[1\] <https://code.google.com/p/android-apktool/>  
\[2\] <http://forum.xda-developers.com/showthread.php?t=1760133>  
\[3\] <http://forum.xda-developers.com/showthread.php?t=2021796>  

