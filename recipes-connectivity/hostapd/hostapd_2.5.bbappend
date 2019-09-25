FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://hostapd_turris.patch"
SRC_URI += "file://hostapd-enable-80211ac.patch;patchdir=${WORKDIR}/"

SRC_URI += "file://hostapd-2G.conf \
            file://hostapd-5G.conf \
            file://hostapd-2G.service \
            file://hostapd-5G.service \
            file://hostapd-init.sh \
	    file://sec_file.txt  \
	    file://bw_file.txt  \
        "
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

do_install_append () {
         install -d ${D}${sbindir} ${D}${sysconfdir} ${D}${systemd_unitdir}/system/ ${D}${base_libdir}/rdk
         install -m 0644 ${WORKDIR}/hostapd-2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-2G.service ${D}${systemd_unitdir}/system
         install -m 0644 ${WORKDIR}/hostapd-5G.service ${D}${systemd_unitdir}/system
         install -m 0755 ${WORKDIR}/hostapd-init.sh ${D}${base_libdir}/rdk
	 install -m 755 ${WORKDIR}/sec_file.txt ${D}${sysconfdir}
    	 install -m 755 ${WORKDIR}/bw_file.txt ${D}${sysconfdir}
}

SYSTEMD_SERVICE_${PN}_append = " hostapd-2G.service hostapd-5G.service"

FILES_${PN} += " \
                ${systemd_unitdir}/system/hostapd-2G.service \
                ${systemd_unitdir}/system/hostapd-5G.service \
                ${sysconfdir}/hostapd-2G.conf \
                ${sysconfdir}/hostapd-5G.conf \
		${sysconfdir}/sec_file.txt \
		${sysconfdir}/bw_file.txt \
                ${base_libdir}/rdk/hostapd-init.sh \
"

