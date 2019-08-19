
do_install_append() {
 sed -i "s/PIDFile/#&/" ${D}/lib/systemd/system/zebra.service
}
