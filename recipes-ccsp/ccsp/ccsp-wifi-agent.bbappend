require ccsp_common_turris.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

LDFLAGS += " \
	-lutopiautil \
	   "
#work around for wifi restart_flag=false, for meshagent synchroniztaion
do_configure_prepend() {
sed -i '/wlanRestart == TRUE/!{p;d;};n;a #if defined(ENABLE_FEATURE_MESHWIFI)\n if ((sWiFiDmlSsidStoredCfg[wlanIndex].SSID, sWiFiDmlSsidRunningCfg[wlanIndex].SSID) != 0)\n {\n char arg[256] = {0};\n snprintf(arg, sizeof(arg), "RDK|%d|%s",wlanIndex,sWiFiDmlSsidStoredCfg[wlanIndex].SSID);\n char * const cmd[] = {"/usr/bin/sysevent", "set", "wifi_SSIDName", arg, NULL};\n execvp_wrapper(cmd);\n }\n #endif\n'  ${S}/source/TR-181/sbapi/cosa_wifi_apis.c
}

SRC_URI_append = " \
    file://wifiTelemetrySetup.sh \
    file://checkwifi.sh \
    file://radio_param_def.cfg \
    file://synclease.sh \
    file://init_easy_connect-fix.patch;apply=no \
"

# we need to patch to code for Turris
do_turris_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/init_easy_connect-fix.patch
        touch patch_applied
    fi
}
addtask turris_patches after do_unpack before do_compile

do_install_append(){
    install -m 777 ${D}/usr/bin/CcspWifiSsp -t ${D}/usr/ccsp/wifi/
    install -m 755 ${S}/scripts/cosa_start_wifiagent.sh ${D}/usr/ccsp/wifi
    install -m 777 ${WORKDIR}/wifiTelemetrySetup.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/checkwifi.sh ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/radio_param_def.cfg ${D}/usr/ccsp/wifi/
    install -m 777 ${WORKDIR}/synclease.sh ${D}/usr/ccsp/wifi/
}

FILES_${PN} += " \
    ${prefix}/ccsp/wifi/CcspWifiSsp \
    ${prefix}/ccsp/wifi/cosa_start_wifiagent.sh \
    ${prefix}/ccsp/wifi/wifiTelemetrySetup.sh \
    ${prefix}/ccsp/wifi/checkwifi.sh \
    ${prefix}/ccsp/wifi/radio_param_def.cfg \
    ${prefix}/ccsp/wifi/synclease.sh \
"
