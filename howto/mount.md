# Mount device

*debian* | *motorola moto g*

Connect your device and find its vendor id.

    $ lsusb | grep Motorola
    Bus 002 Device 003: ID 22b8:2e76 Motorola PCS

Set-up `udev` and add an entry\[1\] with the vendor id corresponding to your device (`22b8`).

    $ sudo vim /etc/udev/rules.d/51-android.rules

> `SUBSYSTEMS=="usb",ATTRS{idVendor}=="22b8",MODE="0666",GROUP="plugdev"`

    $ sudo chmod +x /etc/udev/rules.d/51-android.rules
    $ sudo service udev restart

Enable debug mode on your device and reconnect it.

\[1\] <http://www.circuidipity.com/mtp.html>
