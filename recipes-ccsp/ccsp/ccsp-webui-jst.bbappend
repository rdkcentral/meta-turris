require ccsp_common_turris.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

EXTRA_OECONF += "PHP_RPATH=no"

SRC_URI += "${CMF_GIT_ROOT}/rdkb/devices/raspberrypi/sysint;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/devices;name=webuijst"
SRCREV_webuijst = "${AUTOREV}"

SRC_URI_append = " \
         file://CcspWebUI.sh \
         file://CcspWebUI.service \
"
inherit systemd
do_install_append () {
                install -d ${D}${sysconfdir}
                install -d ${D}${base_libdir}/rdk/
                install -d ${D}${systemd_unitdir}/system/

                # delete wan0 reference for Turris
                sed -i "/wan0:80/a  echo \"This interface is not available in Turris\""  ${D}${sysconfdir}/webgui.sh
                sed -i "/wan0:443/a  echo \"This interface is not available in Turris\""  ${D}${sysconfdir}/webgui.sh
                sed -i "s/if \[ \"\$BOX_TYPE\" == \"HUB4\" \]/if \[ \"\$BOX_TYPE\" = \"HUB4\" \]/g" ${D}${sysconfdir}/webgui.sh
                sed -i '/wan0/d' ${D}${sysconfdir}/webgui.sh

                #delete server.pem reference for TurrisOmnia
                sed -e '/server.pem/ s/^#*/echo "Removed server.pem references for Turris"\n#/' -i ${D}${sysconfdir}/webgui.sh

                install -m 755 ${WORKDIR}/CcspWebUI.sh ${D}${base_libdir}/rdk/
                install -m 644 ${WORKDIR}/CcspWebUI.service ${D}${systemd_unitdir}/system/

                sed -i '/Security.X_COMCAST-COM_KeyPassphrase/a \
                \t\t\tsetStr("Device.DeviceInfo.X_RDKCENTRAL-COM_ConfigureWiFi", "false", true);' ${D}/usr/www2/actionHandler/ajaxSet_wireless_network_configuration_redirection.jst
                sed -i "s/\$clients_RSSI\[strtoupper(\$Host\[\$i\.toString\(\)\]\['PhysAddress'\])\]/\$Host\[\$i\.toString\(\)\]\['X_CISCO_COM_RSSI'\]/g" ${D}/usr/www2/connected_devices_computers.jst
                sed -i "s/\$wnStatus= (\$wan_enable==\"true\" \&\& \$wan_status==\"Down\") ? \"true\" : \"false\";/\$wnStatus= (\$wan_enable==\"true\" \&\& \$wan_status==\"Up\") ? \"true\" : \"false\";/g" ${D}/usr/www2/wan_network.jst
                sed -i "s/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") || (inet_pton(\$Wan_IPv6!==\"\"))) \&\&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") \&\& (inet_pton(\$Wan_IPv6!==\"\"))) \&\&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/g" ${D}/usr/www2/index.jst
                sed -i "s/\$Wan_IPv4 = getStr(\"Device.X_CISCO_COM_CableModem.IPAddress\");/\$Wan_IPv4 = getStr(\"Device.DeviceInfo.X_COMCAST-COM_CM_IP\");/g" ${D}/usr/www2/captiveportal.jst
                sed -i "s/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") || (inet_pton(\$Wan_IPv6!==\"\"))) \&\&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") \&\& (inet_pton(\$Wan_IPv6!==\"\"))) \&\&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/g" ${D}/usr/www2/captiveportal.jst
                sed -i "s/\/usr\/www/\/usr\/www2/g" ${D}${systemd_unitdir}/system/CcspWebUI.service
}

SYSTEMD_SERVICE_${PN} += "CcspWebUI.service"
FILES_${PN} += "${systemd_unitdir}/system/CcspWebUI.service ${base_libdir}/rdk/*"
