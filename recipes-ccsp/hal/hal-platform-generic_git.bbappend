SRC_URI += "${CMF_GITHUB_ROOT}/rdkcentral/rdkb-turris-hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_MASTER_BRANCH};destsuffix=git/source/platform/devices;name=platformhal-turris"

SRCREV = "${AUTOREV}"

DEPENDS += "utopia-headers"
CFLAGS_append = " \
    -I=${includedir}/utctx \
"

do_configure_prepend(){
    rm ${S}/platform_hal.c
    ln -sf ${S}/devices/source/platform/platform_hal.c ${S}/platform_hal.c
}
