require ccsp_common_turris.inc

DEPENDS_append_dunfell = " ccsp-lm-lite"

LDFLAGS_append_dunfell = " -lsafec-3.5.1"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

CFLAGS += " -DDHCPV4_CLIENT_UDHCPC -DDHCPV6_CLIENT_DIBBLER "

CFLAGS_append = " -Wno-unused-function"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://ccsp_misc_dibbler_client.patch;apply=no"

do_turris_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/ccsp_misc_dibbler_client.patch
        touch patch_applied
    fi
}
addtask turris_patches after do_unpack before do_compile

