FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "${CMF_GITHUB_ROOT}/rdkb-turris-hal;protocol=${CMF_GIT_PROTOCOL};branch=${CMF_GITHUB_MASTER_BRANCH};destsuffix=git/source/platform/devices_turris;name=platformhal-turris"
SRC_URI_append = " file://turris-6g-model.patch;apply=no"

SRCREV = "${AUTOREV}"

DEPENDS += "utopia-headers"
CFLAGS_append = " \
    -I=${includedir}/utctx \
"

do_configure_prepend(){
    rm ${S}/platform_hal.c
    ln -sf ${S}/devices_turris/source/platform/platform_hal.c ${S}/platform_hal.c
}

do_turris_patches() {
    cd ${S}/devices_turris/source/platform/
    if [ ! -e patch_applied ]; then
        if ${@bb.utils.contains('DISTRO_FEATURES', 'triband-6g-capable', 'true', 'false', d)}; then
            patch -p1 < ${WORKDIR}/turris-6g-model.patch
        fi
        touch patch_applied
    fi
}
addtask turris_patches after do_unpack before do_compile

CFLAGS_append += "${@bb.utils.contains('DISTRO_FEATURES', 'triband-6g-capable', '-DRDK_BAND_6G', '', d)}"
