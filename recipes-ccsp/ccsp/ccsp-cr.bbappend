require ccsp_common_turris.inc
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://cr-deviceprofile_turris.xml \
"

do_install_append() {
    # Config files and scripts
    install -m 644 ${WORKDIR}/cr-deviceprofile_turris.xml ${D}/usr/ccsp/cr-deviceprofile.xml
    install -m 644 ${WORKDIR}/cr-deviceprofile_turris.xml ${D}/usr/ccsp/cr-ethwan-deviceprofile.xml
}

LDFLAGS_append_dunfell = " -lpthread -lbreakpadwrapper"
