FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://hostapd_turris.patch"
SRC_URI += "file://hostapd-enable-80211ac.patch;patchdir=${WORKDIR}/"

SRC_URI += "file://hostapd-2G.conf \
            file://hostapd-5G.conf \
            file://hostapd-2G.service \
            file://hostapd-5G.service \
            file://hostapd-init.sh \
        "
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

do_install_append () {
         install -d ${D}${sbindir} ${D}${sysconfdir} ${D}${systemd_unitdir}/system/ ${D}${base_libdir}/rdk
         install -m 0644 ${WORKDIR}/hostapd-2G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-5G.conf ${D}${sysconfdir}
         install -m 0644 ${WORKDIR}/hostapd-2G.service ${D}${systemd_unitdir}/system
         install -m 0644 ${WORKDIR}/hostapd-5G.service ${D}${systemd_unitdir}/system
         install -m 0755 ${WORKDIR}/hostapd-init.sh ${D}${base_libdir}/rdk
}

SYSTEMD_SERVICE_${PN}_append = " hostapd-2G.service hostapd-5G.service"

FILES_${PN} += " \
                ${systemd_unitdir}/system/hostapd-2G.service \
                ${systemd_unitdir}/system/hostapd-5G.service \
                ${sysconfdir}/hostapd-2G.conf \
                ${sysconfdir}/hostapd-5G.conf \
                ${base_libdir}/rdk/hostapd-init.sh \
"

