do_install_append_broadband() {
 rm -rf ${D}${base_sbindir}/hwclock
 rm -rf ${D}${base_bindir}/more
 rm -rf ${D}${base_bindir}/kill
 rm -rf ${D}${base_bindir}/dmesg
 rm -rf ${D}${bindir}/chrt
 rm -rf ${D}${bindir}/eject
 rm -rf ${D}${bindir}/flock
 rm -rf ${D}${bindir}/hexdump
 rm -rf ${D}${bindir}/logger
 rm -rf ${D}${bindir}/mesg
 rm -rf ${D}${bindir}/renice
 rm -rf ${D}${bindir}/setsid
}
do_install_append_dunfell_broadband() {
 rm -rf ${D}${base_sbindir}/swapon
 rm -rf ${D}${base_sbindir}/swapoff
 rm -rf ${D}${base_sbindir}/losetup
}
