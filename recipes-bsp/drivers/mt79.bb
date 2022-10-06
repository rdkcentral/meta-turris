SUMMARY = "Firmware for mt76 USB wifi module"
LICENSE = "Proprietary"
COMMENT = "Proprietary license allows the use of the firmware with conditions as in the license file at LIC_FILES_CHKSUM"
LIC_FILES_CHKSUM = "file://firmware/LICENSE;md5=1bff2e28f0929e483370a43d4d8b6f8e"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "git://github.com/openwrt/mt76;branch=master;protocol=https"
SRC_URI += " file://mt76_mt7921_mt7915_MK.patch "
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"
DEPENDS = "virtual/kernel"

inherit module

EXTRA_OEMAKE  = "ARCH=${ARCH}"
EXTRA_OEMAKE += "KSRC=${STAGING_KERNEL_BUILDDIR}"

do_compile () {
    unset LDFLAGS
    oe_runmake
}

do_install () {
    install -d ${D}/lib/modules/${KERNEL_VERSION}
    install -m 0755 ${B}/mt76.ko ${D}/lib/modules/${KERNEL_VERSION}/
    install -m 0755 ${B}/mt76-connac-lib.ko ${D}/lib/modules/${KERNEL_VERSION}/mt76-connac-lib.ko
    install -m 0755 ${B}/mt76-usb.ko ${D}/lib/modules/${KERNEL_VERSION}/mt76-usb.ko
    install -d ${D}/lib/modules/${KERNEL_VERSION}/mt7921
    install -m 0755 ${B}/mt7921/mt7921-common.ko ${D}/lib/modules/${KERNEL_VERSION}/mt7921/mt7921-common.ko
    install -m 0755 ${B}/mt7921/mt7921e.ko ${D}/lib/modules/${KERNEL_VERSION}/mt7921/mt7921e.ko
    install -m 0755 ${B}/mt7921/mt7921u.ko ${D}/lib/modules/${KERNEL_VERSION}/mt7921/mt7921u.ko
    install -d ${D}/lib/modules/${KERNEL_VERSION}/mt7915
    install -m 0755 ${B}/mt7915/mt7915e.ko ${D}/lib/modules/${KERNEL_VERSION}/mt7915/mt7915e.ko
    install -d ${D}${base_libdir}/firmware/mediatek
    install -m 755 ${S}/firmware/WIFI_MT7961_patch_mcu_1_2_hdr.bin ${D}${base_libdir}/firmware/mediatek
    install -m 755 ${S}/firmware/WIFI_RAM_CODE_MT7961_1.bin ${D}${base_libdir}/firmware/mediatek
}
FILES_${PN} += "${base_libdir}/firmware/mediatek/*"

RPROVIDES_${PN} += "kernel-module-${PN}-${KERNEL_VERSION}"
RPROVIDES_${PN} += "kernel-module-${PN}-connac-lib-${KERNEL_VERSION}" 
RPROVIDES_${PN} += "kernel-module-${PN}-usb-${KERNEL_VERSION}" 
