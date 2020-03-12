FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "${CMF_GITHUB_ROOT}/rdkcentral/rdkb-turris-hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_MASTER_BRANCH};destsuffix=git/source/wifi/devices;name=wifihal-turris"

SRCREV = "${AUTOREV}"

DEPENDS += "halinterface libnl libev hostapd wpa-supplicant"

do_configure_prepend(){
    rm ${S}/wifi_hal.c
    rm ${S}/Makefile.am
    ln -sf ${S}/devices/source/wifi/wifi_hal.c ${S}/wifi_hal.c
    ln -sf ${S}/devices/source/wifi/wifi_hostapd_interface.c ${S}/wifi_hostapd_interface.c
    ln -sf ${S}/devices/include/wifi_hal_turris.h ${S}/wifi_hal_turris.h
    ln -sf ${S}/devices/source/wifi/Makefile.am ${S}/Makefile.am
}

CFLAGS_append = " -I=${includedir}/ccsp -I=${includedir}/libnl3"
LDFLAGS_append = " -lnl-nf-3 -lnl-route-3 -lnl-3 -lnl-xfrm-3 -lnl-genl-3 -lev -lwpa_client"
