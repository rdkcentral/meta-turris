require ccsp_common_turris.inc

do_install_append() {
    # Config files and scripts
    install -m 644 ${S}/config-arm/CcspCMDM.cfg ${D}${prefix}/ccsp/cm/CcspCMDM.cfg
    install -m 644 ${S}/config-arm/CcspCM.cfg ${D}${prefix}/ccsp/cm/CcspCM.cfg
    install -m 644 ${S}/config-arm/TR181-CM.XML ${D}${prefix}/ccsp/cm/TR181-CM.XML

    # delete files that are installed by some other package
    rm -f ${D}/usr/include/ccsp/cosa_apis.h
    rm -f ${D}/usr/include/ccsp/cosa_apis_busutil.h
    rm -f ${D}/usr/include/ccsp/cosa_dml_api_common.h
}
