# Mount device

*debian*

Create images of dimension `w x h`, store as 8-bit PNG **without** transparency layer.
Edit txt file

Zip the directory in store mode, i.e. `-mx=0`.

    $ sudo apt-get install p7zip
    $ 7za a -tzip -mx=0 ../bootanimation.zip *

Copy the bootanimation to your device

    $ adb push ../bootanimation.zip /sdcard/
    $ adb shell
    $ su
    # mount -o remount,rw /system
    # cp /sdcard/bootanimation.zip /system/media/
    # chmod 644 /system/media/bootanimation.zip
    # mount -o remount,ro /system
    # exit
    # exit

\[1\] <http://forum.xda-developers.com/showthread.php?t=1852621>
