SUMMARY = "OpenSource MultiAP Agent implementation"
LICENSE = "BSD-2-Clause-Patent"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e1988ff7324cb957bcbf231f1bc6486c"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI = "git://github.com/TechnicolorEDGM/libmultiap_platform.git \
           file://0001-Makefile-changes.patch \
          "

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

DEPENDS = "libuv"

CFLAGS_append = " -I./include"

LDFLAGS_append = " "

do_install () {
    # installing headers and libraries
    install -d ${D}/usr/lib
}
