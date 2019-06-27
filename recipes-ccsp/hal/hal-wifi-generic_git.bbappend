SRC_URI += "${CMF_GIT_ROOT}/rdkb/devices/raspberrypi/hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_BRANCH};destsuffix=git/source/wifi/devices;name=wifihal-raspberrypi"
SRCREV = "${AUTOREV}"

do_configure_prepend(){
    touch /mnt/vol/ralber040/TURRIS/HAL_BUILD/raj.txt
    rm ${S}/wifi_hal.c
    rm ${S}/Makefile.am
    ln -sf ${S}/devices/source/wifi/wifi_hal.c ${S}/wifi_hal.c
    ln -sf ${S}/devices/source/wifi/wifi_hostapd_interface.c ${S}/wifi_hostapd_interface.c
    ln -sf ${S}/devices/include/wifi_hal.h ${S}/wifi_hal.h
    ln -sf ${S}/devices/source/wifi/Makefile.am ${S}/Makefile.am
}

