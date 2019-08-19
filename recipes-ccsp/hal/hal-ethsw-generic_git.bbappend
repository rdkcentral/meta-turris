SRC_URI += "git://github.com/rdkcentral/rdkb-turris-hal;protocol=https;branch=master;destsuffix=git/source/ethsw/devices;name=ethswhal-turris"

SRCREV_ethswhal-turris = "${AUTOREV}"

do_configure_prepend(){
   ln -sf ${S}/devices/source/hal-ethsw/ccsp_hal_ethsw.c ${S}/ccsp_hal_ethsw.c
}

