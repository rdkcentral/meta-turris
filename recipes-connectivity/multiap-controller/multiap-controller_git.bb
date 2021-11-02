SUMMARY = "OpenSource Multiapcontroller implementation"
LICENSE = "BSD-2-Clause-Patent"
LIC_FILES_CHKSUM = "file://LICENSE;md5=d5d0e19d5fa4af3f7d9817fb77a9bfb1"

DEPENDS = "openssl libpcap"
S = "${WORKDIR}/git"

SRC_URI = "git://github.com/TechnicolorEDGM/multiap_controller.git;protocol=https"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

CFLAGS_append = " \
                "

LDFLAGS_append = " \
    -lpthread \
    -lpcap \
    -lcrypto \
    -lrt \
    "

do_install () {
    # Config files and scripts
    install -d ${D}/usr/bin
}
