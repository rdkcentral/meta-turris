FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
file://enabling_dhcp_lease_resync.patch \
file://meshwifi-rename-opensync.patch \
file://meshagent-enable-ovs-default.patch \
"

DEPENDS_append_dunfell = " safec trower-base64"
RDEPENDS_${PN}_append_dunfell = " bash"


do_configure_prepend()  {
patch  -p1 < ${WORKDIR}/enabling_dhcp_lease_resync.patch ${S}/source/MeshAgentSsp/cosa_mesh_apis.c  || echo "patch already applied"
patch  -p1 < ${WORKDIR}/meshwifi-rename-opensync.patch ${S}/systemd_units/meshwifi.service || echo "patch already applied"
patch  -p1 < ${WORKDIR}/meshagent-enable-ovs-default.patch ${S}/source/MeshAgentSsp/cosa_mesh_apis.c || echo "patch already applied"
}

do_install_append () {
       install -D -m 0644 ${S}/systemd_units/meshAgent.service ${D}${systemd_unitdir}/system/meshAgent.service
}

FILES_${PN}_append = "${systemd_unitdir}/system/meshAgent.service"

CFLAGS_append = " -D_PLATFORM_TURRIS_"

LDFLAGS_append_dunfell = " -lsyscfg -lsysevent -lbreakpadwrapper -lsafec-3.5.1"

LDFLAGS_remove_dunfell = "-lsafec-3.5"
