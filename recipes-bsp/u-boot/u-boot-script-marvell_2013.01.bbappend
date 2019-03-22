FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-script-marvell/db-88f6820-gp:"

SRC_URI_remove = "file://bootscript"

SRC_URI += "file://db-88f6820-gp/bootscript"

BOOTSCRIPT = "${S}/db-88f6820-gp/bootscript"

do_mkimage () {
    uboot-mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
                  -n "boot script" -d ${BOOTSCRIPT} ${S}/boot.scr
}

