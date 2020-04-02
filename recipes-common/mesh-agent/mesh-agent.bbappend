FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "\
file://enabling_dhcp_lease_resync.patch \
"

do_configure_prepend()  {
patch  -p3 --forward < ${WORKDIR}/dns.patch ${S}/source/MeshAgentSsp/cosa_mesh_apis.c  || echo "patch already applied"
}

CFLAGS_append = " -D_PLATFORM_TURRIS_"


