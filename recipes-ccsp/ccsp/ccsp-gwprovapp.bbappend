FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

require ccsp_common_turris.inc

SRC_URI += " file://turris-macro-gwprov.patch;apply=no"
SRC_URI += " file://set-uplink-for-turris.patch;apply=no"

# we need to patch to code for Turris
do_rpi_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/turris-macro-gwprov.patch
        patch -p1 < ${WORKDIR}/set-uplink-for-turris.patch
        touch patch_applied
    fi
}
addtask rpi_patches after do_unpack before do_compile

export PLATFORM_TURRIS_ENABLED="yes"

FILES_${PN} += " \
    /usr/bin/gw_prov_utopia \
"
