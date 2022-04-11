FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
file://enabling_dhcp_lease_resync.patch;apply=no \
file://meshagent-enable-ovs-default.patch;apply=no \
file://skip-apply-settings.patch;apply=no \
file://noc_url.patch;apply=no \
"

DEPENDS_append_dunfell = " safec trower-base64"
RDEPENDS_${PN}_append_dunfell = " bash"

# we need to patch to code for mesh-agent
do_turris_meshagent_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        bbnote "Patching enabling_dhcp_lease_resync.patch"
        patch  -p1 < ${WORKDIR}/enabling_dhcp_lease_resync.patch ${S}/source/MeshAgentSsp/cosa_mesh_apis.c

        bbnote "Patching meshagent-enable-ovs-default.patch"
        patch  -p1 < ${WORKDIR}/meshagent-enable-ovs-default.patch ${S}/source/MeshAgentSsp/cosa_mesh_apis.c

        bbnote "Patching skip-apply-settings.patch"
        patch  -p1 < ${WORKDIR}/skip-apply-settings.patch ${S}/source/MeshAgentSsp/cosa_mesh_apis.c

        bbnote "Patching NOC-URL for Meshagent"
        patch  -p1 < ${WORKDIR}/noc_url.patch ${S}/source/MeshAgentSsp/cosa_mesh_apis.c

        touch patch_applied
    fi
}
addtask turris_meshagent_patches after do_unpack before do_configure

do_install_append () {
       install -D -m 0644 ${S}/systemd_units/meshAgent.service ${D}${systemd_unitdir}/system/meshAgent.service
}

FILES_${PN}_append = "${systemd_unitdir}/system/meshAgent.service"

CFLAGS_append = " -D_PLATFORM_TURRIS_"

LDFLAGS_append_dunfell = " -lsyscfg -lsysevent -lbreakpadwrapper -lsafec-3.5.1"

LDFLAGS_remove_dunfell = "-lsafec-3.5"
