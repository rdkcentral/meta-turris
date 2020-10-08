FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-script-marvell/db-88f6820-gp:"

SRC_URI_remove_dunfell = "file://bootscript"

SRC_URI_dunfell += "file://db-88f6820-gp/bootscript"

BOOTSCRIPT_dunfell = "${S}/db-88f6820-gp/bootscript"

do_mkimage_dunfell () {
    uboot-mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
                  -n "boot script" -d ${BOOTSCRIPT} ${S}/boot.scr
}

