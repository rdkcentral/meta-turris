require ccsp_common_turris.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

LDFLAGS_append = " -Wl,--no-as-needed"

SRC_URI += "file://musl-header-missing.patch;apply=no"

# we need to patch to code for Turris
do_rpi_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/musl-header-missing.patch
        touch patch_applied
    fi
}
addtask rpi_patches after do_unpack before do_compile
