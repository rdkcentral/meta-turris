require ccsp_common_turris.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-RDKBCMF-279-CcspEthAgent-build-failure-when-WanManag.patch;apply=no"

EXTRA_OECONF_append  = " --with-ccsp-arch=arm"

LDFLAGS_append =" \
    -lsyscfg \
    -lbreakpadwrapper \
"
LDFLAGS_append_dunfell = " -lpthread -lsafec-3.5.1"

# we need to patch to code for Turris
do_turris_patches() {
    cd ${S}
    if [ ! -e patch_applied ]; then
        patch -p1 < ${WORKDIR}/0001-RDKBCMF-279-CcspEthAgent-build-failure-when-WanManag.patch
       touch patch_applied
    fi
}
addtask turris_patches after do_unpack before do_compile
