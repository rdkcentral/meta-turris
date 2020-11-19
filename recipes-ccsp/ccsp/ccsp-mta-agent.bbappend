require ccsp_common_turris.inc

DEPENDS_append_dunfell = " safec"
LDFLAGS_append_dunfell = " -lsafec-3.5.1"

do_install_append() {
    # Config files and scripts
    install -m 644 ${S}/config/CcspMtaAgent.xml ${D}/usr/ccsp/mta/CcspMtaAgent.xml
    install -m 644 ${S}/config/CcspMta.cfg ${D}/usr/ccsp/mta/CcspMta.cfg
    install -m 644 ${S}/config/CcspMtaLib.cfg ${D}/usr/ccsp/mta/CcspMtaLib.cfg
}
