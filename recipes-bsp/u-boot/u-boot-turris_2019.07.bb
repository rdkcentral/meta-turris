require recipes-bsp/u-boot/u-boot.inc

DESCRIPTION = "U-Boot for Turris Omnia"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://README;md5=030fd86c891b64ce88b7aa3cff0fbd44"

PROVIDES += "u-boot"

DEPENDS_append = " dtc-native"

DEPENDS_dunfell += " bison-native bc-native"

SRC_URI = " \
    git://git@gitlab.labs.nic.cz/turris/turris-omnia-uboot;branch=${SRCBRANCH};protocol=https \
"

SRCBRANCH = "omnia-2019"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

COMPATIBLE_MACHINE = "turris"
PACKAGES += "u-boot"
