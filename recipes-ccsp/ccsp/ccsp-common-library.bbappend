require ccsp_common_turris.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS_append_turris = " breakpad"
CXXFLAGS_append_turris = " \
                                -I${STAGING_INCDIR}/breakpad \
                                -std=c++11 \
                              "

SRC_URI_append = " \
    file://ccsp_vendor.h \
    file://wifiinitialized.service \
    file://checkturriswifisupport.service \
    file://wifiinitialized.path \
    file://turriswifiinitialized.path \
    file://checkturriswifisupport.path \
    file://wifi-initialized.target \
"

SRC_URI += "file://0003-add-dependency-to-pandm.patch;apply=no"
SRC_URI += "file://0004-remove-psm-db-reference.patch;apply=no"

# we need to patch to code for Turris
do_rpi_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/0003-add-dependency-to-pandm.patch
        patch -p1 < ${WORKDIR}/0004-remove-psm-db-reference.patch
        touch patch_applied
    fi
}
addtask rpi_patches after do_unpack before do_compile

do_install_append(){
    # Config files and scripts
    install -m 777 ${S}/scripts/cli_start_arm.sh ${D}/usr/ccsp/cli_start.sh
    install -m 777 ${S}/scripts/cosa_start_arm.sh ${D}/usr/ccsp/cosa_start.sh

    # we need unix socket path
    echo "unix:path=/var/run/dbus/system_bus_socket" > ${S}/config/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/cm/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/mta/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/pam/ccsp_msg.cfg
    install -m 644 ${S}/config/ccsp_msg.cfg ${D}/usr/ccsp/tr069pa/ccsp_msg.cfg

    install -m 777 ${S}/systemd_units/scripts/ccspSysConfigEarly.sh ${D}/usr/ccsp/ccspSysConfigEarly.sh
    install -m 777 ${S}/systemd_units/scripts/ccspSysConfigLate.sh ${D}/usr/ccsp/ccspSysConfigLate.sh
    install -m 777 ${S}/systemd_units/scripts/utopiaInitCheck.sh ${D}/usr/ccsp/utopiaInitCheck.sh
    install -m 777 ${S}/systemd_units/scripts/ccspPAMCPCheck.sh ${D}/usr/ccsp/ccspPAMCPCheck.sh

    install -m 777 ${S}/systemd_units/scripts/crResetCheck.sh ${D}/usr/ccsp/crResetCheck.sh
    sed -i -e "s/source \/rdklogger\/logfiles.sh;syncLogs_nvram2/#source \/rdklogger\/logfiles.sh;syncLogs_nvram2/g" ${D}/usr/ccsp/crResetCheck.sh
    # install systemd services
    install -d ${D}${systemd_unitdir}/system
    install -D -m 0644 ${S}/systemd_units/ccspwifiagent.service ${D}${systemd_unitdir}/system/ccspwifiagent.service
    install -D -m 0644 ${S}/systemd_units/CcspCrSsp.service ${D}${systemd_unitdir}/system/CcspCrSsp.service
    install -D -m 0644 ${S}/systemd_units/CcspPandMSsp.service ${D}${systemd_unitdir}/system/CcspPandMSsp.service
    install -D -m 0644 ${S}/systemd_units/PsmSsp.service ${D}${systemd_unitdir}/system/PsmSsp.service
    install -D -m 0644 ${S}/systemd_units/rdkbLogMonitor.service ${D}${systemd_unitdir}/system/rdkbLogMonitor.service
    install -D -m 0644 ${S}/systemd_units/CcspTandDSsp.service ${D}${systemd_unitdir}/system/CcspTandDSsp.service
    install -D -m 0644 ${S}/systemd_units/CcspLMLite.service ${D}${systemd_unitdir}/system/CcspLMLite.service
    install -D -m 0644 ${S}/systemd_units/CcspTr069PaSsp.service ${D}${systemd_unitdir}/system/CcspTr069PaSsp.service
    install -D -m 0644 ${S}/systemd_units/snmpSubAgent.service ${D}${systemd_unitdir}/system/snmpSubAgent.service
    install -D -m 0644 ${S}/systemd_units/snmpSubAgent.service ${D}${systemd_unitdir}/system/snmpSubAgent.service
    install -D -m 0644 ${S}/systemd_units/CcspEthAgent.service ${D}${systemd_unitdir}/system/CcspEthAgent.service

    #rfc service file
    install -D -m 0644 ${S}/systemd_units/rfc.service ${D}${systemd_unitdir}/system/rfc.service

    install -D -m 0644 ${WORKDIR}/wifiinitialized.service ${D}${systemd_unitdir}/system/wifiinitialized.service
    install -D -m 0644 ${WORKDIR}/checkturriswifisupport.service ${D}${systemd_unitdir}/system/checkturriswifisupport.service

    install -D -m 0644 ${WORKDIR}/wifiinitialized.path ${D}${systemd_unitdir}/system/wifiinitialized.path
    install -D -m 0644 ${WORKDIR}/turriswifiinitialized.path ${D}${systemd_unitdir}/system/turriswifiinitialized.path
    install -D -m 0644 ${WORKDIR}/checkturriswifisupport.path ${D}${systemd_unitdir}/system/checkturriswifisupport.path

    install -D -m 0644 ${WORKDIR}/wifi-initialized.target ${D}${systemd_unitdir}/system/wifi-initialized.target

    install -D -m 0644 ${S}/systemd_units/crResetDetect.service ${D}${systemd_unitdir}/system/crResetDetect.service
    install -D -m 0644 ${S}/systemd_units/crResetDetect.path ${D}${systemd_unitdir}/system/crResetDetect.path
    install -D -m 0644 ${S}/systemd_units/logagent.service ${D}${systemd_unitdir}/system/logagent.service

    # Install wrapper for breakpad (disabled to support External Source build)
    #install -d ${D}${includedir}/ccsp
    #install -m 644 ${S}/source/breakpad_wrapper/include/breakpad_wrapper.h ${D}${includedir}/ccsp

    # Install "vendor information"
    install -m 0644 ${WORKDIR}/ccsp_vendor.h ${D}${includedir}/ccsp

    sed -i -- 's/NotifyAccess=.*/#NotifyAccess=main/g' ${D}${systemd_unitdir}/system/CcspCrSsp.service
    sed -i -- 's/notify.*/forking/g' ${D}${systemd_unitdir}/system/CcspCrSsp.service
   
    #copy rfc.properties into nvram
    sed -i '/ExecStartPre/ a\ExecStartPre=-/bin/cp /etc/rfc.properties /nvram/' ${D}${systemd_unitdir}/system/rfc.service
    #reduce sleep time to 12 sconds
    sed -i 's/300/12/g' ${D}${systemd_unitdir}/system/rfc.service
   
    #change for turris omnia
    sed -i 's/PIDFile/#&/' ${D}${systemd_unitdir}/system/CcspPandMSsp.service 
}

SYSTEMD_SERVICE_${PN} += "ccspwifiagent.service"
SYSTEMD_SERVICE_${PN} += "CcspCrSsp.service"
SYSTEMD_SERVICE_${PN} += "CcspPandMSsp.service"
SYSTEMD_SERVICE_${PN} += "PsmSsp.service"
SYSTEMD_SERVICE_${PN} += "rdkbLogMonitor.service"
SYSTEMD_SERVICE_${PN} += "CcspTandDSsp.service"
SYSTEMD_SERVICE_${PN} += "CcspLMLite.service"
SYSTEMD_SERVICE_${PN} += "CcspTr069PaSsp.service"
SYSTEMD_SERVICE_${PN} += "snmpSubAgent.service"
SYSTEMD_SERVICE_${PN} += "CcspEthAgent.service"
SYSTEMD_SERVICE_${PN} += "wifiinitialized.service"
SYSTEMD_SERVICE_${PN} += "checkturriswifisupport.service"
SYSTEMD_SERVICE_${PN} += "wifiinitialized.path"
SYSTEMD_SERVICE_${PN} += "turriswifiinitialized.path"
SYSTEMD_SERVICE_${PN} += "checkturriswifisupport.path"
SYSTEMD_SERVICE_${PN} += "wifi-initialized.target"
SYSTEMD_SERVICE_${PN} += "crResetDetect.path"
SYSTEMD_SERVICE_${PN} += "crResetDetect.service"
SYSTEMD_SERVICE_${PN} += "logagent.service"
SYSTEMD_SERVICE_${PN} += "rfc.service"

FILES_${PN}_append = " \
    /usr/ccsp/ccspSysConfigEarly.sh \
    /usr/ccsp/ccspSysConfigLate.sh \
    /usr/ccsp/utopiaInitCheck.sh \
    /usr/ccsp/ccspPAMCPCheck.sh \
    /usr/ccsp/crResetCheck.sh \
    ${systemd_unitdir}/system/ccspwifiagent.service \
    ${systemd_unitdir}/system/CcspCrSsp.service \
    ${systemd_unitdir}/system/CcspPandMSsp.service \
    ${systemd_unitdir}/system/PsmSsp.service \
    ${systemd_unitdir}/system/rdkbLogMonitor.service \
    ${systemd_unitdir}/system/CcspTandDSsp.service \
    ${systemd_unitdir}/system/CcspLMLite.service \
    ${systemd_unitdir}/system/CcspTr069PaSsp.service \
    ${systemd_unitdir}/system/snmpSubAgent.service \
    ${systemd_unitdir}/system/CcspEthAgent.service \
    ${systemd_unitdir}/system/wifiinitialized.service \
    ${systemd_unitdir}/system/checkturriswifisupport.service \
    ${systemd_unitdir}/system/wifiinitialized.path \
    ${systemd_unitdir}/system/turriswifiinitialized.path \
    ${systemd_unitdir}/system/checkturriswifisupport.path \
    ${systemd_unitdir}/system/wifi-initialized.target \
    ${systemd_unitdir}/system/crResetDetect.path \
    ${systemd_unitdir}/system/crResetDetect.service \
    ${systemd_unitdir}/system/logagent.service \
    ${systemd_unitdir}/system/rfc.service \
"
