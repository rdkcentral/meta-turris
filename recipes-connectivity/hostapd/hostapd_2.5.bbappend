FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://hostapd_turris.patch"
SRC_URI += "file://hostapd-enable-80211ac.patch;patchdir=${WORKDIR}/"
