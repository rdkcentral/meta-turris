SRC_URI += "${RDKCENTRAL_GITHUB_ROOT}/rdkb-turris-hal;protocol=${RDKCENTRAL_GITHUB_PROTOCOL};branch=${RDKCENTRAL_GITHUB_BRANCH};destsuffix=git/source/wifi/devices;name=wifihal-turris"

SRCREV = "${AUTOREV}"

DEPENDS += "halinterface"

do_configure_prepend(){
    rm ${S}/wifi_hal.c
    rm ${S}/Makefile.am
    ln -sf ${S}/devices/source/wifi/wifi_hal.c ${S}/wifi_hal.c
    ln -sf ${S}/devices/source/wifi/wifi_hostapd_interface.c ${S}/wifi_hostapd_interface.c
    ln -sf ${S}/devices/include/wifi_hal_turris.h ${S}/wifi_hal_turris.h
    ln -sf ${S}/devices/source/wifi/Makefile.am ${S}/Makefile.am
}

CFLAGS_append = " -I=${includedir}/ccsp"
