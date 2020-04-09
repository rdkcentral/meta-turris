FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_append_extender = " \
    file://systemd-turris.patch \
"
SRC_URI_append = " \
    file://systemd-set-wdt.patch \
    file://systemd-strerror_r-handling.patch \
    "
