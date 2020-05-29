require ccsp_common_turris.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

LDFLAGS += " \
	-lutopiautil \
	   "

DEPENDS += "avro-c"
	
SRC_URI_append = " \
    file://wifiTelemetrySetup.sh \
    file://checkwifi.sh \
    file://radio_param_def.cfg \
"
do_install_append(){
    install -m 777 ${D}/usr/bin/CcspWifiSsp -t ${D}/usr/ccsp/wifi/
    install -m 755 ${S}/scripts/cosa_start_wifiagent.sh ${D}/usr/ccsp/wifi
    install -m 777 ${WORKDIR}/wifiTelemetrySetup.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/radio_param_def.cfg ${D}/usr/ccsp/wifi/
}

FILES_${PN} += " \
    ${prefix}/ccsp/wifi/CcspWifiSsp \
    ${prefix}/ccsp/wifi/cosa_start_wifiagent.sh \
    ${prefix}/ccsp/wifi/wifiTelemetrySetup.sh \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/radio_param_def.cfg \
"
