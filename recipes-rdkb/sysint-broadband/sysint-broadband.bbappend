FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://TurrisFwUpgrade.sh"

do_install_append() {
    echo "BOX_TYPE=turris" >> ${D}${sysconfdir}/device.properties
    echo "ARM_INTERFACE=erouter0" >> ${D}${sysconfdir}/device.properties
    install -d ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/TurrisFwUpgrade.sh ${D}${base_libdir}/rdk
}
