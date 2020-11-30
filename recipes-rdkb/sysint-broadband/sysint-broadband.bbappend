FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRCREV_FORMAT = "${AUTOREV}"

SRC_URI += "file://TurrisFwUpgrade.sh"
SRC_URI += "file://swupdate_utility.sh"
SRC_URI += "file://swupdate.service"
SRC_URI += "file://commonUtils.sh \
            file://dcaSplunkUpload.sh \
            file://dca_utility.sh \
            file://interfaceCalls.sh \
            file://DCMscript.sh \
            file://logfiles.sh \
            file://StartDCM.sh \
            file://uploadSTBLogs.sh \
            file://getaccountid.sh \
            file://getpartnerid.sh \
            file://utils.sh \
            file://dcm-log.service"

SYSTEMD_SERVICE_${PN} = "swupdate.service"
SYSTEMD_SERVICE_${PN} = "dcm-log.service"

do_install_append() {
    echo "BOX_TYPE=turris" >> ${D}${sysconfdir}/device.properties
    echo "ARM_INTERFACE=erouter0" >> ${D}${sysconfdir}/device.properties
    install -d ${D}${base_libdir}/rdk
    install -d ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/TurrisFwUpgrade.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/swupdate_utility.sh ${D}${base_libdir}/rdk
    install -m 0644 ${WORKDIR}/swupdate.service ${D}${systemd_unitdir}/system

    #DCM simulator Support
    install -m 0644 ${S}/dcmlogservers.txt   ${D}/rdklogger/
    install -m 0755 ${WORKDIR}/StartDCM.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/DCMscript.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/uploadSTBLogs.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/dcaSplunkUpload.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/dca_utility.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/interfaceCalls.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/commonUtils.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/logfiles.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/getaccountid.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/getpartnerid.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/utils.sh ${D}${base_libdir}/rdk
    install -m 0755 ${WORKDIR}/dcm-log.service ${D}${systemd_unitdir}/system
}

FILES_${PN} += "${systemd_unitdir}/system/swupdate.service"
FILES_${PN} += "${systemd_unitdir}/system/dcm-log.service"

RDEPENDS_${PN}_append_dunfell = " bash"
