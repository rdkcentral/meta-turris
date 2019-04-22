require ccsp_common_turris.inc

do_install_append_turris () {
    ln -sf ${bindir}/dmcli ${D}${bindir}/ccsp_bus_client_tool
}
