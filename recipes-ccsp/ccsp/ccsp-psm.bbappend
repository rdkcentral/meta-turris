require ccsp_common_turris.inc

do_configure_append() {
    install -m 644 ${S}/source-arm/psm_hal_apis.c -t ${S}/source/Ssp
}

do_install_append() {
    # Config files and scripts
    install -d ${D}/usr/ccsp/config
    install -m 644 ${S}/config/bbhm_def_cfg_qemu.xml ${D}/usr/ccsp/config/bbhm_def_cfg.xml
    install -m 755 ${S}/scripts/bbhm_patch.sh ${D}/usr/ccsp/psm/bbhm_patch.sh
#    sed -i '/NotifyWiFiChanges/a \
#      <Record name="eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.1.SSID" type="astr">RPI3_RDKB-AP0</Record> \
#      <Record name="eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.2.SSID" type="astr">RPI3_RDKB-AP1</Record> \
#      <Record name="eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.1.Passphrase" type="astr">rdk@1234</Record> \
#      <Record name="eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.2.Passphrase" type="astr">rdk@1234</Record>' ${D}/usr/ccsp/config/bbhm_def_cfg.xml
}
