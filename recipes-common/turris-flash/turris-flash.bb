SUMMARY = "Flash related files for Turris"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS_${PN} = "bash"

inherit systemd

SRC_URI = "file://TurrisFwUpgrade.sh"
SRC_URI += "file://nvram.mount"

do_compile[noexec] = "1"
do_configure[noexec] = "1"

do_install() {
    install -d ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/TurrisFwUpgrade.sh ${D}${base_libdir}/rdk/

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/nvram.mount ${D}${systemd_unitdir}/system/
}

SYSTEMD_SERVICE_${PN} = "nvram.mount"

FILES_${PN} = "${base_libdir}/rdk/TurrisFwUpgrade.sh"
FILES_${PN} += "${systemd_unitdir}/system/nvram.mount"
