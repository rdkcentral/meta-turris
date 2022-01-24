FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://sta-network.patch;apply=no"

#This is workaround for missing do_patch when RDK uses external sources
do_turris_patches() {
    cd ${S}
        if [ ! -e patch_applied ]; then
            patch -p1 < ${WORKDIR}/sta-network.patch
            touch patch_applied
        fi
}
addtask turris_patches after do_unpack before do_compile

CFLAGS_append = " -DWIFI_HAL_VERSION_3"
