# Mount device using the Media Transfer Protocol (MTP)

*debian* | *motorola moto g*

Install and set-up `mtpfs`\[1\].

    $ sudo apt-get install mtpfs mtp-tools
    $ sudo adduser `id -un` fuse
    $ sudo mkdir -p -m 777 /media/moto-g
    $ sudo modprobe fuse

Logout and login to activate the new group permissions.

Now plugin and mount the Moto G.

    $ sudo mtpfs /media/moto-g

Before unplugging, run

    $ sudo umount mtpfs

\[1\] <http://www.circuidipity.com/mtp.html>
