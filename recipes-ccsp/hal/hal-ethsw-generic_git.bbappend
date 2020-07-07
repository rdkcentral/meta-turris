SRC_URI += "${CMF_GITHUB_ROOT}/rdkb-turris-hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GIT_MASTER_BRANCH};destsuffix=git/source/ethsw/devices;name=ethswhal-turris"

SRCREV_ethswhal-turris = "${AUTOREV}"

do_configure_prepend(){
   ln -sf ${S}/devices/source/hal-ethsw/ccsp_hal_ethsw.c ${S}/ccsp_hal_ethsw.c
}
