require ccsp_common_turris.inc

LDFLAGS_append_dunfell = " -lsafec-3.5.1"

do_install_append() {
    # Config files and scripts
    install -d ${D}/usr/ccsp/config
    install -m 644 ${S}/config/bbhm_def_cfg_qemu.xml ${D}/usr/ccsp/config/bbhm_def_cfg.xml
    install -m 755 ${S}/scripts/bbhm_patch.sh ${D}/usr/ccsp/psm/bbhm_patch.sh
#    sed -i '/NotifyWiFiChanges/a \
#      <Record name="eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.1.SSID" type="astr">TURRIS_RDKB-AP0</Record> \
#      <Record name="eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.2.SSID" type="astr">TURRIS_RDKB-AP1</Record> \
#      <Record name="eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.1.Passphrase" type="astr">rdk@1234</Record> \
#      <Record name="eRT.com.cisco.spvtg.ccsp.Device.WiFi.Radio.SSID.2.Passphrase" type="astr">rdk@1234</Record>' ${D}/usr/ccsp/config/bbhm_def_cfg.xml

#WanManager Feature
    DISTRO_WAN_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','rdkb_wan_manager','true','false',d)}"
    if [ $DISTRO_WAN_ENABLED = 'true' ]; then
    sed -i '/AccessPoint.16.vAPStatsEnable/a \
   <!-- rdkb-wanmanager related --> \
   <Record name="dmsb.wanmanager.wanenable" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.wanifcount" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.wanpolicy" type="astr">2</Record> \ 
   <Record name="dmsb.wanmanager.wanidletimeout" type="astr">0</Record> \
   <Record name="dmsb.selfheal.rebootstatus"  type="astr">0</Record> \
   <Record name="dmsb.wanmanager.if.1.Name" type="astr">eth2</Record> \
   <Record name="dmsb.wanmanager.if.1.DisplayName" type="astr">WanOE</Record> \
   <Record name="dmsb.wanmanager.if.1.Enable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.Type" type="astr">2</Record> \
   <Record name="dmsb.wanmanager.if.1.Priority" type="astr">0</Record> \
   <Record name="dmsb.wanmanager.if.1.SelectionTimeout" type="astr">0</Record> \
   <Record name="dmsb.wanmanager.if.1.DynTriggerEnable" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.DynTriggerDelay" type="astr">0</Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.List" type="astr">DATA</Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.DATA.Alias" type="astr">DATA</Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.DATA.SKBPort" type="astr">1</Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.DATA.SKBMark" type="astr"> </Record> \
   <Record name="dmsb.wanmanager.if.1.Marking.DATA.EthernetPriorityMark" type="astr"></Record> \
   <Record name="dmsb.wanmanager.if.1.PPPEnable" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPLinkType" type="astr">PPPoE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPIPCPEnable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPIPV6CPEnable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.PPPIPCPEnable" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.ActiveLink" type="astr">TRUE</Record> \
   <Record name="dmsb.wanmanager.if.1.EnableMAPT" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.EnableDSLite" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.EnableIPoEHealthCheck" type="astr">FALSE</Record> \
   <Record name="dmsb.wanmanager.if.1.RebootOnConfiguration" type="astr">FALSE</Record>' ${D}/usr/ccsp/config/bbhm_def_cfg.xml
    fi
}

LDFLAGS_append_dunfell = " -lpthread"
