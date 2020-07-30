#!/bin/bash

if [ $1 ] ; then
echo "Usage '/lib/rdk/FwUgrade.sh'"
echo "Note: New images should be downloaded in /tmp directory"
exit 1
fi

check ()
{
  if [ $? != 0 ]; then
    echo $*
    exit 1
  fi
}

ls /tmp/zImage* >/dev/null
check "No new image present in /tmp directory"

ActivePartition=`fw_printenv yocto_bootargs | cut -d' ' -f3 | cut -d'=' -f2`
if [ $ActivePartition == "/dev/mmcblk0p5" ]; then
  TargetPartition="/dev/mmcblk0p7"
else
  TargetPartition="/dev/mmcblk0p5"
fi
echo "ActivePartition: $ActivePartition"
echo "TargetPartition: $TargetPartition"

umount /mnt 2>/dev/null
echo y | mkfs.ext2 ${TargetPartition}
check "Error in formatting ${TargetPartition}"

mount ${TargetPartition} /mnt
check "Error in mounting ${TargetPartition}"

tar -xzf /tmp/*.tar.gz -C /mnt
check "Error in unpacking new image"

umount /mnt
check "Error in unmounting"
echo "New rootfs is loaded in ${TargetPartition}"

mount /dev/mmcblk0p3 /mnt/
check "Error in mounting /dev/mmcblk0p3"

mv /mnt/zImage /zImage_old
cp /tmp/zImage* /mnt/zImage
if [ $? != 0 ]; then
echo "Error in copying zImage. Falling back."
mv /zImage_old /mnt/zImage
exit 1
fi

fw_setenv yocto_bootargs earlyprintk console=ttyS0,115200 root=$TargetPartition rootfstype=ext2 rw rootwait
