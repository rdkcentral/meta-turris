require ccsp_common_turris.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

EXTRA_OECONF += "PHP_RPATH=no"

SRC_URI_append = " \
	 file://CcspWebUI.sh \
	 file://CcspWebUI.service \
"

do_install_append () {
    install -d ${D}${sysconfdir}
    install -m 755 ${S}/../Styles/xb3/config/php.ini ${D}${sysconfdir}

    # delete wan0 reference for TurrisOmnia
    sed -i "/wan0:80/a  echo \"This interface is not available in Turris\""  ${D}${sysconfdir}/webgui.sh
    sed -i "/wan0:443/a  echo \"This interface is not available in Turris\""  ${D}${sysconfdir}/webgui.sh
    sed -i '/wan0/d' ${D}${sysconfdir}/webgui.sh

    #delete server.pem reference for TurrisOmnia
    sed -e '/server.pem/ s/^#*/echo "Removed server.pem references for R-pi"\n#/' -i ${D}${sysconfdir}/webgui.sh

    sed -i -e "s/'TCP',\ 'UDP',\ 'TCP\/UDP'/'TCP',\ 'UDP',\ 'BOTH'/g" ${D}/usr/www/actionHandler/ajax_managed_services.php
    sed -i '/Security.X_COMCAST-COM_KeyPassphrase/a \
    \t\t\tsetStr("Device.DeviceInfo.X_RDKCENTRAL-COM_ConfigureWiFi", "false", true);' ${D}/usr/www/actionHandler/ajaxSet_wireless_network_configuration_redirection.php
	sed -i -e "s/https:\/\/webui-xb3-cpe-srvr.xcal.tv/http:\/\/'.\$ip_addr.'/g" ${D}/usr/www/index.php
	sed -i -e "s/LIGHTTPD_PID=\`pidof lighttpd\`/LIGHTTPD_PID=\`pidof lighttpd php-cgi\`/g" ${D}${sysconfdir}/webgui.sh
	sed -i -e "s/\/bin\/kill \$LIGHTTPD_PID/\/bin\/kill -9 \$LIGHTTPD_PID/g" ${D}${sysconfdir}/webgui.sh
        #Remove Mesh-Mode Validation on TurrisOmnia
        sed -i -e "s/&& (\$Mesh_Mode==\"false\")//g" ${D}/usr/www/actionHandler/ajaxSet_wireless_network_configuration_edit.php
	sed -i "/setting ConfigureWiFi to true/a echo \"}\" >> \$LIGHTTPD_CONF" ${D}${sysconfdir}/webgui.sh
	sed -i "/setting ConfigureWiFi to true/a echo \"}\" >> \$LIGHTTPD_CONF" ${D}${sysconfdir}/webgui.sh
	sed -i "/setting ConfigureWiFi to true/a echo \"\\\\\$HTTP[\\\\\"host\\\\\"] !~ \\\\\":8080\\\\\" {  \\\\\$HTTP[\\\\\"url\\\\\"] !~ \\\\\"captiveportal.php\\\\\" {  \\\\\$HTTP[\\\\\"referer\\\\\"] == \\\\\"\\\\\" { url.redirect = ( \\\\\".*\\\\\" => \\\\\"http://10.0.0.1/captiveportal.php\\\\\" ) url.redirect-code = 303 }\" >> \$LIGHTTPD_CONF"  ${D}${sysconfdir}/webgui.sh
	sed -i "/setting ConfigureWiFi to true/a                          sed -i \'\/server.modules              = \(\/a \"mod_rewrite\",' \$LIGHTTPD_CONF" ${D}${sysconfdir}/webgui.sh
	sed -i "/setting ConfigureWiFi to true/a sed -i \'\/server.modules              = \(\/a \"mod_redirect\",' \$LIGHTTPD_CONF" ${D}${sysconfdir}/webgui.sh
        sed -i "s/if((!strcmp(\$url, \$Wan_IPv4) || ((inet_pton(\$url)!=\"\") || (inet_pton(\$Wan_IPv6!==\"\"))) &&(inet_pton(\$url) == inet_pton(\$Wan_IPv6)))){/if(!strcmp(\$url, \$Wan_IPv4) || (inet_pton(\$url) == inet_pton(\$Wan_IPv6))){/g" ${D}/usr/www/index.php

	install -m 755 ${WORKDIR}/CcspWebUI.sh ${D}${base_libdir}/rdk/
	install -m 644 ${WORKDIR}/CcspWebUI.service ${D}${systemd_unitdir}/system/
        sed -i "/jProgress/a alert(\'DOCSIS Support is not available in RPI Boards\'); die();" ${D}/usr/www/wan_network.php
        sed -e '/jProgress/ s/^/\/\//' -i ${D}/usr/www/wan_network.php
        sed -i "s/\$clients_RSSI\[strtoupper(\$Host\[\"\$i\"\]\['PhysAddress'\])\]/\$Host\[\$i\]\['X_CISCO_COM_RSSI'\]/g" ${D}/usr/www/connected_devices_computers.php
}
do_install_append_morty () {
    #Locate svg file to load
    echo  "<?php \n\$files = glob('/run/log/bootchart-[0-9]*?-[0-9]*?.svg');\necho file_get_contents(\$files[0]);\n?>" > ${D}/usr/www/bootchart.php

    #Include bootchart.php in nav.php
   sed -i "/password_change.php/a echo '<li class="nav-bootchart"><a role="menuitem"  href="bootchart.php">Bootchart</a></li>';" ${D}/usr/www/includes/nav.php
}

SYSTEMD_SERVICE_${PN} += "CcspWebUI.service"
FILES_${PN} += "${sysconfdir}/php.ini ${systemd_unitdir}/system/CcspWebUI.service"

