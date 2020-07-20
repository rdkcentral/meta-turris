FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "${@bb.utils.contains('DISTRO_FEATURES', 'extender', 'file://sta-network.patch;apply=no', '', d)}"

# we need to patch to code for RPi camera
do_turris_patches() {
    cd ${S}
    if [ -f ${WORKDIR}/sta-network.patch ]; then
        if [ ! -e patch_applied ]; then
            patch -p1 < ${WORKDIR}/sta-network.patch
            touch patch_applied
        fi
    fi
}
addtask turris_patches after do_unpack before do_compile
