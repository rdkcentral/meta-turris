FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "git://git@github.com/rdkcentral/rdkb-turris-hal.git;protocol=ssh;branch=turris-rdk-next;name=wifihal"

SRCREV = "${AUTOREV}"

DEPENDS += "halinterface libnl hostapd wpa-supplicant"

CFLAGS_append = " -I=${includedir}/ccsp -I=${includedir}/libnl3"
LDFLAGS_append = " -lnl-nf-3 -lnl-route-3 -lnl-3 -lnl-xfrm-3 -lnl-genl-3"
