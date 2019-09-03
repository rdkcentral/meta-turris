do_install_append() {
    echo "BOX_TYPE=rpi" >> ${D}${sysconfdir}/device.properties
}
