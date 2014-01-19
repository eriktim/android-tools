#/bin/sh

W=`identify -format '%w' $1`
H=`identify -format '%h' $1`
if [ $W -ne 720 ] || [ $H -ne 1280 ]; then
  echo "Image must be 720x1280 pixels"
  exit
fi
convert -depth 8 $1 bgr:logo_boot.raw
cp logo.bin log-custom.bin
perl src/moto-g-compress.pl logo_boot.raw
rm logo_boot.raw
LEN=`stat -c '%s' logo_boot.bin`
if [ "$((LEN+12))" -gt 467109 ]; then
  echo "Compressed image is too large"
  rm  logo-custom.bin
  exit
fi
dd if=logo_boot.bin conv=notrunc seek=524 bs=1 count=$LEN of=logo-custom.bin
dd if=logo-custom.bin conv=notrunc skip=104 seek=40 bs=1 count=4 of=logo-custom.bin
dd if=logo-custom.bin conv=notrunc skip=36 seek=100 bs=1 count=4 of=logo-custom.bin
rm logo_boot.bin

