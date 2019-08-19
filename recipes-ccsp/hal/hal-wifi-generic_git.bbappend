SRC_URI += "git://github.com/rdkcentral/rdkb-turris-hal;protocol=https;branch=master;destsuffix=git/source/wifi/devices;name=wifihal-turris"
SRCREV = "${AUTOREV}"

do_configure_prepend(){
    rm ${S}/wifi_hal.c
    rm ${S}/Makefile.am
    ln -sf ${S}/devices/source/wifi/wifi_hal.c ${S}/wifi_hal.c
    ln -sf ${S}/devices/source/wifi/wifi_hostapd_interface.c ${S}/wifi_hostapd_interface.c
    ln -sf ${S}/devices/include/wifi_hal.h ${S}/wifi_hal.h
    ln -sf ${S}/devices/source/wifi/Makefile.am ${S}/Makefile.am
}

