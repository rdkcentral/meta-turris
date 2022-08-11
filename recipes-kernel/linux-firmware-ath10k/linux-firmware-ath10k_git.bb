SUMMARY = "Firmware files for ATH10K driver"
DESCRIPTION = "Firmware only for ath10k from linux-firmware repo taken for installation."
HOMEPAGE = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware"
SECTION = "kernel"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENCE.atheros_firmware;md5=30a14c7823beedac9fa39c64fdd01a13"

DEPENDS = "virtual/kernel"

PV = "git${SRCPV}"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git;protocol=https;branch=main"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

PROVIDES = "linux-firmware-ath10k"
RPROVIDES_${PN} = "linux-firmware-ath10k"

do_configure() {
}
do_compile() {
}

FILES_${PN} += "/lib/firmware/ath10k/QCA988X/hw2.0/*"
do_install() {
	install -d ${D}/lib/firmware/ath10k/QCA988X/hw2.0/
	install -D -m 0644 ${S}/ath10k/QCA988X/hw2.0/* ${D}/lib/firmware/ath10k/QCA988X/hw2.0/
}
