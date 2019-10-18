SRC_URI += "${RDKCENTRAL_GITHUB_ROOT}/rdkb-turris-hal;protocol=${RDKCENTRAL_GITHUB_PROTOCOL};branch=${RDKCENTRAL_GITHUB_BRANCH};destsuffix=git/source/platform/devices;name=platformhal-turris"

SRCREV = "${AUTOREV}"

DEPENDS += "utopia-headers"
CFLAGS_append = " \
    -I=${includedir}/utctx \
"

do_configure_prepend(){
    rm ${S}/platform_hal.c
    ln -sf ${S}/devices/source/platform/platform_hal.c ${S}/platform_hal.c
}
