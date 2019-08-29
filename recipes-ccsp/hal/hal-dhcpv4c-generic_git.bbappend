SRC_URI += "${RDKCENTRAL_GITHUB_ROOT}/rdkb-turris-hal;protocol=${RDKCENTRAL_GITHUB_PROTOCOL};branch=${RDKCENTRAL_GITHUB_BRANCH};destsuffix=git/source/dhcpv4c/devices;name=dhcphal-turris"

SRCREV_dhcphal-turris = "${AUTOREV}"

do_configure_prepend(){
    rm ${S}/dhcpv4c_api.c
    ln -sf ${S}/devices/source/dhcpv4c/dhcpv4c_api.c ${S}/dhcpv4c_api.c
}

