SRC_URI += "${CMF_GITHUB_ROOT}/rdkb-turris-hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GITHUB_MASTER_BRANCH};destsuffix=git/source/ethsw/devices_turris;name=ethswhal-turris"

SRCREV_ethswhal-turris = "${AUTOREV}"

do_configure_prepend(){
   ln -sf ${S}/devices_turris/source/hal-ethsw/ccsp_hal_ethsw.c ${S}/ccsp_hal_ethsw.c
}
