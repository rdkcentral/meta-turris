SRC_URI_append = " \
    ${CMF_GIT_ROOT}/rdkb/devices/raspberrypi/sysint;module=.;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/devicerpi;name=sysintdevicerpi \
"
SRCREV_sysintdevicerpi = "${AUTOREV}"
SRCREV_FORMAT = "sysintgeneric_sysintdevicerpi"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRCREV_FORMAT = "${AUTOREV}"

SRC_URI_remove = "${CMF_GIT_ROOT}/rdkb/devices/intel-x86-pc/emulator/sysint;module=.;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/device;name=sysintdevice"

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
    echo "CLOUDURL="http://35.155.171.121:9092/xconf/swu/stb?eStbMac="" >> ${D}${sysconfdir}/include.properties

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
    echo "DCM_LOG_SERVER_URL="http://35.155.171.121:9092/loguploader/getSettings"" >> ${D}${sysconfdir}/dcm.properties
    echo "DCM_HTTP_SERVER_URL="http://35.155.171.121/xconf/telemetry_upload.php"" >> ${D}${sysconfdir}/dcm.properties
    echo "DCM_LA_SERVER_URL="http://35.155.171.121/xconf/logupload.php"" >> ${D}${sysconfdir}/dcm.properties
    echo "TFTP_SERVER_IP=35.155.171.121" >> ${D}${sysconfdir}/device.properties
    echo "MODEL_NAME=Turris" >> ${D}${sysconfdir}/device.properties

    #Log Rotate Support
    sed -i "/if \[ \! -f \/usr\/bin\/GetConfigFile \]\;then/,+4d" ${D}/rdklogger/logfiles.sh
    sed -i "/uploadRDKBLogs.sh/a \ \t \t  \t  uploading_rdklogs" ${D}/rdklogger/rdkbLogMonitor.sh
    sed -i "/uploadRDKBLogs.sh/d " ${D}/rdklogger/rdkbLogMonitor.sh
    sed -i "/upload_nvram2_logs()/i uploading_rdklogs() \n { \n \ \t \t TFTP_RULE_COUNT=\`iptables -t raw -L -n | grep tftp | wc -l\` \n \ \t \t if [ \"\$TFTP_RULE_COUNT\" == 0 ] \n \t \t then \n \ \t \t \t iptables -t raw -I OUTPUT -j CT -p udp -m udp --dport 69 --helper tftp \n \ \t \t \t sleep 2 \n \ \t \t fi \n \ \t \t cd /nvram/logbackup \n \ \t \t FILENAME=\`ls *.tgz\` \n \ \t \t tftp -p -r \$FILENAME \$TFTP_SERVER_IP \n } " ${D}/rdklogger/rdkbLogMonitor.sh

    install -m 0755 ${S}/devicerpi/lib/rdk/run_rm_key.sh   ${D}${base_libdir}/rdk
}

FILES_${PN} += "${systemd_unitdir}/system/swupdate.service"
FILES_${PN} += "${systemd_unitdir}/system/dcm-log.service"

RDEPENDS_${PN}_append_dunfell = " bash"
