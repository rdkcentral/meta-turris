SRC_URI += "${CMF_GITHUB_ROOT}/rdkb-turris-hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GITHUB_MASTER_BRANCH};destsuffix=git/source/dhcpv4c/devices_turris;name=dhcphal-turris"

SRCREV_dhcphal-turris = "${AUTOREV}"

do_configure_prepend(){
    rm ${S}/dhcpv4c_api.c
    ln -sf ${S}/devices_turris/source/dhcpv4c/dhcpv4c_api.c ${S}/dhcpv4c_api.c
}

