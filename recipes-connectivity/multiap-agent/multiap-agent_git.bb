SUMMARY = "OpenSource MultiAP Agent implementation"
LICENSE = "BSD-2-Clause-Patent"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e1988ff7324cb957bcbf231f1bc6486c"

S = "${WORKDIR}/git"

SRC_URI = "git://github.com/TechnicolorEDGM/multiap_agent.git;protocol=https"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

#CFLAGS_append = " "

#LDFLAGS_append = " "

do_install () {
    install -d ${D}/usr/bin
}
