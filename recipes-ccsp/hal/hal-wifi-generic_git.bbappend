FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "${CMF_GITHUB_ROOT}/rdkcentral/rdkb-turris-hal.git;protocol=${CMF_GIT_PROTOCOL};branch=turris-rdk-next;name=wifihal"

SRCREV = "${AUTOREV}"

DEPENDS += "halinterface libnl hostapd wpa-supplicant"

CFLAGS_append = " -I=${includedir}/ccsp -I=${includedir}/libnl3"
LDFLAGS_append = " -lnl-nf-3 -lnl-route-3 -lnl-3 -lnl-xfrm-3 -lnl-genl-3"
