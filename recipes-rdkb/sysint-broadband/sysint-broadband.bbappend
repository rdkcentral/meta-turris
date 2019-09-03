do_install_append() {
    echo "BOX_TYPE=turris" >> ${D}${sysconfdir}/device.properties
}
