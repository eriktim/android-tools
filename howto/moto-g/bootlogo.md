# Change bootlogo

*debian* | *motorola moto g*

Extract `logo.bin` from the device.

    $ adb shell su -c "dd if=/dev/block/platform/msm_sdcc.1/by-name/logo of=/sdcard/logo.bin count=1 bs=634418"
    $ adb pull /sdcard/logo.bin .

View the images wrapped in `logo.bin`

    $ ./moto-g-extract-bootlogo.sh

Create a custom logo `logo.png` and insert it into a copy of `logo.bin`.

    $ ./moto-g-insert-bootlogo.sh logo.png

Boot device into fastmode mode.

    $ fastboot flash logo logo-custom.bin

\[1\] <http://forum.xda-developers.com/showthread.php?t=2548530>  
\[2\] <http://forum.xda-developers.com/showpost.php?p=48891456&postcount=140>
