require ccsp_common_turris.inc

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://include_platform_turris.patch;apply=no"

# we need to patch to code for Turris
do_turris_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/include_platform_turris.patch
        touch patch_applied
    fi
}
addtask turris_patches after do_unpack before do_compile

LDFLAGS_append =" \
    -lsyscfg \
    -lbreakpadwrapper \
"
LDFLAGS_append_dunfell = " -lpthread -lsafec-3.5.1"
