FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://systemd-turris.patch"
SRC_URI += "file://systemd-set-wdt.patch"
SRC_URI += "file://systemd-strerror_r-handling.patch"
