SUMMARY = "Flash related files for Turris"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS_${PN} = "bash"

SRC_URI = "file://TurrisFwUpgrade.sh"

do_compile[noexec] = "1"
do_configure[noexec] = "1"

do_install() {
    install -d ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/TurrisFwUpgrade.sh ${D}${base_libdir}/rdk
}

FILES_${PN} = "${base_libdir}/rdk/TurrisFwUpgrade.sh"
