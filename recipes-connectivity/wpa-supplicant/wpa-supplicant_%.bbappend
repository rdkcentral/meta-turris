FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://wpa_supplicant-global.service"

SYSTEMD_SERVICE_${PN} = "wpa_supplicant-global.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

do_install_append () {
   install -m 0644 ${WORKDIR}/wpa_supplicant-global.service ${D}${systemd_unitdir}/system/
}

