require ccsp_common_turris.inc

do_install_append() {
    # Config files and scripts
    install -m 644 ${S}/config/CcspMtaAgent.xml ${D}/usr/ccsp/mta/CcspMtaAgent.xml
    install -m 644 ${S}/config/CcspMta.cfg ${D}/usr/ccsp/mta/CcspMta.cfg
    install -m 644 ${S}/config/CcspMtaLib.cfg ${D}/usr/ccsp/mta/CcspMtaLib.cfg
}
