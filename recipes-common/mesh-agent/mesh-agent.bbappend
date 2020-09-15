FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
file://enabling_dhcp_lease_resync.patch \
"

do_configure_prepend()  {
patch  -p1 < ${WORKDIR}/enabling_dhcp_lease_resync.patch ${S}/source/MeshAgentSsp/cosa_mesh_apis.c  || echo "patch already applied"
}

do_install_append () {
	install -D -m 0644 ${S}/systemd_units/meshAgent.service ${D}${systemd_unitdir}/system/meshAgent.service
}

FILES_${PN}_append = "${systemd_unitdir}/system/meshAgent.service"

CFLAGS_append = " -D_PLATFORM_TURRIS_"


