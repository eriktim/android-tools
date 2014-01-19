#/bin/sh

rm -f tmp_logo_*.png

OFF1=`echo "ibase=16; 000200" | bc`
LEN1=`echo "ibase=16; 0720A5" | bc`
OFF2=`echo "ibase=16; 072400" | bc`
LEN2=`echo "ibase=16; 003304" | bc`
OFF3=`echo "ibase=16; 075800" | bc`
LEN3=`echo "ibase=16; 025632" | bc`

dd if=logo.bin skip=$OFF1 bs=1 count=$LEN1 of=tmp_logo_boot.bin
dd if=logo.bin skip=$OFF2 bs=1 count=$LEN2 of=tmp_logo_battery.bin
dd if=logo.bin skip=$OFF3 bs=1 count=$LEN3 of=tmp_logo_unlocked.bin

perl src/moto-g-decompress.pl tmp_logo_boot.bin
convert -depth 8 -size 720x1280 bgr:temp.raw logo_boot.png
rm temp.raw tmp_logo_boot.bin

perl src/moto-g-decompress.pl tmp_logo_battery.bin
convert -depth 8 -size 540x540 bgr:temp.raw logo_battery.png
rm temp.raw tmp_logo_battery.bin

perl src/moto-g-decompress.pl tmp_logo_unlocked.bin
convert -depth 8 -size 540x540 bgr:temp.raw logo_unlocked.png
rm temp.raw tmp_logo_unlocked.bin

