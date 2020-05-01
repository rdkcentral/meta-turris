require recipes-kernel/linux/linux-marvell.inc

SOC_SRC_URI = "git://git@github.com/MarvellEmbeddedProcessors/linux-marvell.git;protocol=https"
SRCBRANCH = "linux-4.14.22-armada-18.06"

SRC_URI[md5sum] = "c843b0c21354a0cf8f2f8fdad5293770"
SRC_URI[sha256sum] = "d4cef396cb7e6ef4c4a82a789eaa9e2479c1cdce22c4c797ebb712be5a1fd56c"

SRCREV = "1357b78ad32c3dfc4933f8613ae3755e7b314eb6"
SRC_URI += "file://402-ath_regd_optional.patch \
	    file://regdb.patch \
           "
SRC_URI += "${@bb.utils.contains('TUNE_FEATURES', 'bigendian', 'file://big-endian.cfg',  '', d)}"

SRC_URI_append_clearfog = " \
    file://iptables.cfg \
"
SRC_URI += " \
    file://ath-reg.cfg \
    file://openvswitch.cfg \
"

DEPENDS += " u-boot"
COMPATIBLE_MACHINE = "(armada37xx|armada38x|armada70xx|armada80xx)"

do_install_append() {
    install -d ${D}${includedir}
    install -m 0644 ${B}/include/generated/autoconf.h ${D}${includedir}/autoconf.h
}

sysroot_stage_all_append () {
    install -d ${SYSROOT_DESTDIR}${includedir}
    install -m 0644 ${D}${includedir}/autoconf.h ${SYSROOT_DESTDIR}${includedir}/autoconf.h
}


PACKAGES += "kernel-autoconf"
PROVIDES += "kernel-autoconf"

FILES_kernel-autoconf = "${includedir}/autoconf.h"
