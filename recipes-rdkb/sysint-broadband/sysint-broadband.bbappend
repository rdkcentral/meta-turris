FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://TurrisFwUpgrade.sh"
SRC_URI += "file://swupdate_utility.sh"
SRC_URI += "file://swupdate.service"

SYSTEMD_SERVICE_${PN} = "swupdate.service"

do_install_append() {
    echo "BOX_TYPE=turris" >> ${D}${sysconfdir}/device.properties
    echo "ARM_INTERFACE=erouter0" >> ${D}${sysconfdir}/device.properties
    install -d ${D}${base_libdir}/rdk
    install -d ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/TurrisFwUpgrade.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/swupdate_utility.sh ${D}${base_libdir}/rdk
    install -m 0644 ${WORKDIR}/swupdate.service ${D}${systemd_unitdir}/system
}

FILES_${PN} += "${systemd_unitdir}/system/swupdate.service"
