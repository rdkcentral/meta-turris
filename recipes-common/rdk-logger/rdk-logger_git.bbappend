FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_extender += "file://0001-Add-sys-time-and-select-include.patch;apply=no"

# we need to patch to code for rdk-logger
do_rdk_logger_patches() {
    cd ${S}
    if [ -f ${WORKDIR}/0001-Add-sys-time-and-select-include.patch ]; then
        if [ ! -e patch_applied_rdklogger ]; then
            bbnote "Patching 0001-Add-sys-time-and-select-include.patch"
            patch -p1 < ${WORKDIR}/0001-Add-sys-time-and-select-include.patch

            touch patch_applied_rdklogger
        fi
    fi
}
addtask do_rdk_logger_patches after do_unpack before do_configure
