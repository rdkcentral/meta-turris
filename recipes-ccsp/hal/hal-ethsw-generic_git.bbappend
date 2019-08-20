SRC_URI += "${RDKCENTRAL_GITHUB_ROOT}/rdkb-turris-hal;protocol=${RDKCENTRAL_GITHUB_PROTOCOL};branch=${RDKCENTRAL_GITHUB_BRANCH};destsuffix=git/source/ethsw/devices;name=ethswhal-turris"

SRCREV_ethswhal-turris = "${AUTOREV}"

do_configure_prepend(){
   ln -sf ${S}/devices/source/hal-ethsw/ccsp_hal_ethsw.c ${S}/ccsp_hal_ethsw.c
}
