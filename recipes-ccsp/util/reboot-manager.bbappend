require recipes-ccsp/ccsp/ccsp_common_turris.inc

do_configure_append() {
    install -m 644 ${S}/source-arm/CcspRmHal.c -t ${S}/source/RmSsp
}

do_install_append() {
    # Config files and scripts
    install -m 644 ${S}/config/RebootManager_arm.xml ${D}/usr/ccsp/rm/RebootManager.xml
}
