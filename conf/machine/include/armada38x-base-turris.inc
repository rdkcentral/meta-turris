# Provides the Marvell Armada 38x common settings

require conf/machine/include/tune-cortexa9.inc

DEFAULTTUNE_armada38x ??= "armv7ahf-neon"

MACHINEOVERRIDES =. "armada38x:"

PREFERRED_PROVIDER_u-boot ??= "u-boot-marvell"
PREFERRED_PROVIDER_virtual/bootloader ??= "u-boot-marvell"

PREFERRED_PROVIDER_u-boot-script ??= "u-boot-script-marvell"

# Packages essential for booting
MACHINE_ESSENTIAL_EXTRA_RDEPENDS += " \
    kernel-image \
    kernel-devicetree \
    u-boot-script \
"

IMAGE_FSTYPES += "tar.bz2 ext2 wic.gz"

SERIAL_CONSOLE = "115200 ttyS0"

PREFERRED_PROVIDER_virtual/kernel ?= "linux-marvell"
KERNEL_IMAGETYPE = "zImage"

UBOOT_SUFFIX = "bin"
UBOOT_MACHINE = "armada_38x_config"

WKS_FILES_append_armada38x = " armada38x.wks"
WKS_FILE_DEPENDS ?= ""

MACHINE_FEATURES = "ext2 ipsec nfs pci smbfs usbgadget usbhost vfat"
