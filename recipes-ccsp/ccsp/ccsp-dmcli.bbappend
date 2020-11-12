require ccsp_common_turris.inc

LDFLAGS_append_dunfell = "-lsafec-3.5.1"

do_install_append_turris () {
    ln -sf ${bindir}/dmcli ${D}${bindir}/ccsp_bus_client_tool
}
