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

BootPartition="/dev/mmcblk0p1"
NewTurrisModel=1

ActiveRootPartition=`mount | grep "/" -w | cut -d' ' -f1`
if [ $ActiveRootPartition == "/dev/mmcblk0p2" ]; then
  TargetRootPartition="/dev/mmcblk0p3"
elif [ $ActiveRootPartition == "/dev/mmcblk0p3" ]; then
  TargetRootPartition="/dev/mmcblk0p2"
elif [ $ActiveRootPartition == "/dev/mmcblk0p5" ]; then
  TargetRootPartition="/dev/mmcblk0p7"
  BootPartition="/dev/mmcblk0p3"
  NewTurrisModel=0
else ##if $ActiveRootPartition is "/dev/mmcblk0p7"
  TargetRootPartition="/dev/mmcblk0p5"
  BootPartition="/dev/mmcblk0p3"
  NewTurrisMode=0
fi
echo "ActiveRootPartition: $ActiveRootPartition"
echo "TargetRootPartition: $TargetRootPartition"
echo "BootPartition: $BootPartition"

umount /mnt 2>/dev/null
echo y | mkfs.ext2 $TargetRootPartition
check "Error in formatting $TargetRootPartition"

mount $TargetRootPartition /mnt
check "Error in mounting $TargetRootPartition"

tar -xzf /tmp/*.tar.gz -C /mnt
check "Error in unpacking new rootfs"

umount /mnt
check "Error in unmounting"
echo "New rootfs is loaded in $TargetRootPartition"

mount $BootPartition /mnt/
check "Error in mounting $BootPartition"

mv /mnt/zImage /zImage_old
cp /tmp/zImage* /mnt/zImage
if [ $? != 0 ]; then
echo "Error in copying zImage. Falling back."
mv /zImage_old /mnt/zImage
exit 1
fi

if [ $NewTurrisModel -eq 1 ]; then
  if [ $TargetRootPartition == "/dev/mmcblk0p2" ]; then
    cp /boot-main.scr /mnt/boot.scr
  else
    cp /boot-alt.scr /mnt/boot.scr
  fi
else
  fw_setenv yocto_bootargs earlyprintk console=ttyS0,115200 root=$TargetRootPartition rootfstype=ext2 rw rootwait
fi
