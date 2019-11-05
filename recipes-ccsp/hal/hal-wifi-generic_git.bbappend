SRC_URI += "${RDKCENTRAL_GITHUB_ROOT}/rdkb-turris-hal;protocol=${RDKCENTRAL_GITHUB_PROTOCOL};branch=${RDKCENTRAL_GITHUB_BRANCH};destsuffix=git/source/wifi/devices;name=wifihal-turris"

SRCREV = "${AUTOREV}"

DEPENDS += "halinterface libnl"

do_configure_prepend(){
    rm ${S}/wifi_hal.c
    rm ${S}/Makefile.am
    ln -sf ${S}/devices/source/wifi/wifi_hal.c ${S}/wifi_hal.c
    ln -sf ${S}/devices/source/wifi/Makefile.am ${S}/Makefile.am
}

CFLAGS_append = " -I=${includedir}/ccsp -I=${includedir}/libnl3"
LDFLAGS_append = " -lnl-nf-3 -lnl-route-3 -lnl-3 -lnl-xfrm-3 -lnl-genl-3"
