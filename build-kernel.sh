#!/bin/bash
make clean && make mrproper

schedtool -B -n 1 -e ionice -n 1 make -j$(cat /proc/cpuinfo | grep "^processor" | wc -l) franco_defconfig
echo $1 > .version
schedtool -B -n 1 -e ionice -n 1 make -j$(cat /proc/cpuinfo | grep "^processor" | wc -l)

if [ -e arch/arm/boot/zImage ]; then

cp -f arch/arm/boot/zImage ../ramdisk_one_plus_one/split_img/boot.img-zImage

cd ../ramdisk_one_plus_one/
if [ -e image-new.img ]; then rm -f image-new.img; fi
if [ -e boot.img ]; then rm -f boot.img; fi
if [ -e ramdisk-new.cpio* ]; then rm -f ramdisk-new.cpio*; fi
if [ -e split_img/boot.img-dtb ]; then rm -f split_img/boot.img-dtb; fi
if [ -e split_img/boot.img-ramdisk ]; then rm -f split_img/boot.img-ramdisk; fi
./dtbToolCM -2 -o split_img/boot.img-dtb -s 2048 -p ../one_plus_one/scripts/dtc/ ../one_plus_one/arch/arm/boot/
./repackimg_fixed.sh
mv boot.img ../one_plus_one/boot.img

cd ../one_plus_one/
echo "build succeeded"

else

echo "build failed"
fi
