SUMMARY = "U-Boot bootloader fw_printenv/setenv utilities for Turris Omnia"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://README;md5=030fd86c891b64ce88b7aa3cff0fbd44"
SECTION = "bootloader"
DEPENDS = "mtd-utils"
DEPENDS_append_dunfell = " bison-native"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    git://git@gitlab.labs.nic.cz/turris/turris-omnia-uboot;branch=${SRCBRANCH};protocol=https \
"
SRC_URI += "file://fw_env.config"

SRCBRANCH = "omnia-2019"
SRCREV = "c3cbc14686bbc97a60a72b5dc7d5749b0cce8fbe"

S = "${WORKDIR}/git"

INSANE_SKIP_${PN} = "already-stripped"

EXTRA_OEMAKE_class-target = 'CROSS_COMPILE=${TARGET_PREFIX} HOSTCC=${BUILD_CC} CC="${CC} ${CFLAGS} ${LDFLAGS}"  V=1'
inherit uboot-config

do_compile () {
   oe_runmake ${UBOOT_MACHINE}
   oe_runmake envtools
}

do_install () {
   install -d ${D}${base_sbindir}
   install -d ${D}${sysconfdir}
   install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_printenv
   install -m 755 ${S}/tools/env/fw_printenv ${D}${base_sbindir}/fw_setenv
   install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}

PROVIDES += "u-boot-fw-utils"
RPROVIDES_${PN} += "u-boot-fw-utils"

PACKAGE_ARCH = "${MACHINE_ARCH}"
COMPATIBLE_MACHINE = "turris"
