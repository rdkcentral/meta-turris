# Provides the Marvell Armada 38x common settings
require conf/machine/include/tune-cortexa9.inc
DEFAULTTUNE_armada38x ??= "armv7ahf-neon"
MACHINEOVERRIDES =. "armada38x:"
# Packages essential for booting
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += " \
    kernel-image \
    kernel-devicetree \
    u-boot-script \
"
IMAGE_FSTYPES += "tar.bz2 ext2 wic.bz2"
SERIAL_CONSOLE = "115200 ttyS0"
#PREFERRED_PROVIDER_virtual/kernel ?= "linux-marvell"
KERNEL_IMAGETYPE = "zImage"
PREFERRED_PROVIDER_u-boot ??= "u-boot-turris"
PREFERRED_PROVIDER_u-boot-fw-utils ??= "u-boot-fw-utils-turris"
PREFERRED_RPROVIDER_u-boot-fw-utils ??= "u-boot-fw-utils-turris"
PREFERRED_PROVIDER_u-boot-script ??= "u-boot-script-turris"
PREFERRED_PROVIDER_virtual/bootloader ??= "u-boot-turris"
UBOOT_SUFFIX = "bin"
WKS_FILES_append_armada38x = " armada38x.wks"
WKS_FILE_DEPENDS ?= ""
WKS_FILE ?= "turris.wks"
do_image_wic[depends] += "u-boot-turris:do_populate_sysroot"
MACHINE_FEATURES = "ext2 ipsec nfs pci smbfs usbgadget usbhost vfat"
